class DashboardController < ApplicationController
  def index
    api_key = ENV["GOOGLE_MAPS_API_KEY"]
    place_id = "ChIJ3RSaYE_LD4gRts0TShMrFjc"

    script_output = `python3 /workspaces/gym-session-optimizer/get_busy_times.py #{api_key} #{place_id}`

    begin
      @busy_times = JSON.parse(script_output)
    rescue JSON::ParserError => e
      puts "JSON Parsing Error: #{e.message}"
      @busy_times = {}
    end

    @current_day = Date.today.strftime("%A")

    # Access the 'Hourly Busy Times' data
    hourly_busy_times = @busy_times["Hourly Busy Times"] || []

    # Find the data for the current day
    @chart_data = hourly_busy_times.find { |day| day["name"] == @current_day } || {"name" => @current_day, "data" => []}

    puts "Current Day: #{@current_day}"
    puts "Chart Data: #{@chart_data}"
  end
end

