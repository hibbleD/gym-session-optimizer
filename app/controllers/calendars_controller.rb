class CalendarsController < ApplicationController
  before_action :initialize_client, only: [:callback, :calendars, :redirect]

  def redirect
    redirect_url = @client.authorization_uri.to_s
    respond_to do |format|
      format.json { render json: { url: redirect_url } }
      format.html { redirect_to redirect_url, allow_other_host: true }
    end
  end

  def callback
    @client.code = params[:code]
    response = @client.fetch_access_token!
    session[:authorization] = response
    redirect_to root_path
  end

  def calendars
    @client.update!(session[:authorization])
    service = Google::Apis::CalendarV3::CalendarService.new
    service.authorization = @client

    today = Date.today
    start_time = today.beginning_of_day.rfc3339
    end_time = today.end_of_day.rfc3339

    calendar_id = 'primary'
    events = service.list_events(calendar_id, time_min: start_time, time_max: end_time)

    event_data = extract_event_data(events.items)

    render json: event_data # Render the event data as JSON
  end

  private

  def initialize_client
    @client ||= Signet::OAuth2::Client.new(client_options)
  end

  def client_options
    {
      client_id: ENV.fetch("GOOGLE_CLIENT_ID", ""),
      client_secret: ENV.fetch("GOOGLE_CLIENT_SECRET", ""),
      authorization_uri: "https://accounts.google.com/o/oauth2/auth",
      token_credential_uri: "https://oauth2.googleapis.com/token",
      scope: Google::Apis::CalendarV3::AUTH_CALENDAR_READONLY,
      redirect_uri: callback_url,
    }
  end

  def callback_url
    # Ensure this matches the callback URL you set in Google Cloud Console
    url_for(controller: 'calendars', action: 'callback', only_path: false)
  end

  def extract_event_data(events)
    events.map do |event|
      {
        summary: event.summary,
        start_time: event.start.date_time || event.start.date, # Handle all-day events
        end_time: event.end.date_time || event.end.date # Handle all-day events
      }
    end
  end
end
