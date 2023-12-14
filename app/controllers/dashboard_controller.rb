class DashboardController < ApplicationController
  before_action :load_busy_times_data, only: [:index, :recommend_time]
  before_action :set_current_day, only: [:index, :recommend_time]

  def index
    @user = current_user
    @chart_data = extract_chart_data_for_current_day || default_chart_data
  end

  def recommend_time
    @user = current_user
    @chart_data = extract_chart_data_for_current_day || default_chart_data

    if user_signed_in? && @user.identity.present?
      run_recommendation_algorithm
    else
      flash[:alert] = "Please sign in and link your Google Calendar to get recommendations."
    end

    render :index
  end


  def load_busy_times_data
    api_key = ENV["GOOGLE_MAPS_API_KEY"]
    place_id = "ChIJ3RSaYE_LD4gRts0TShMrFjc"
    script_output = `python3 /workspaces/gym-session-optimizer/scripts/get_busy_times.py #{api_key} #{place_id}`

    begin
      @busy_times = JSON.parse(script_output)["Hourly Busy Times"]
    rescue JSON::ParserError => e
      puts "JSON Parsing Error: #{e.message}"
      @busy_times = nil
    end
  end

  def set_current_day
    @current_day = Date.today.strftime("%A")
  end

  def run_recommendation_algorithm
    calendar_events = CalendarsController.new.fetch_user_calendar_events(@user)
    preferred_start_hour = @user.preferred_start_time&.in_time_zone('Central Time (US & Canada)')&.hour
    preferred_end_hour = @user.preferred_end_time&.in_time_zone('Central Time (US & Canada)')&.hour
    today_busy_times = @chart_data["data"]

    puts "Calendar events: #{calendar_events}" 
    puts "Preferred start hour: #{preferred_start_hour}" 
    puts "Preferred end hour: #{preferred_end_hour}"
    puts "Today's busy times: #{today_busy_times}" 

    @recommended_time = recommend_gym_time(today_busy_times, calendar_events, preferred_start_hour, preferred_end_hour)
  end

  def extract_chart_data_for_current_day
    @busy_times&.find { |day| day["name"] == @current_day }
  end

  def default_chart_data
    { "name" => @current_day, "data" => Array.new(24, 0) }
  end

  def recommend_gym_time(busy_times, calendar_events, start_hour, end_hour)
    available_hours = (start_hour...end_hour).reject do |hour|
      calendar_events.any? { |event| event_during_hour?(event, hour) }
    end

    puts "Available hours: #{available_hours}" 

    least_busy_hour = available_hours.min_by { |hour| busy_times[hour] }
    puts "Least busy hour: #{least_busy_hour}" 

    format_recommended_time(least_busy_hour)
  end

  def event_during_hour?(event, hour)
    event_start_hour = event[:start_time].in_time_zone("Central Time (US & Canada)").hour
    event_end_hour = event[:end_time].in_time_zone("Central Time (US & Canada)").hour
    (event_start_hour...event_end_hour).cover?(hour)
  end

  def format_recommended_time(hour)
    return "No suitable time found" if hour.nil?
    Time.zone.now.beginning_of_day.change(hour: hour).strftime("%H:%M %p")
  end
end
