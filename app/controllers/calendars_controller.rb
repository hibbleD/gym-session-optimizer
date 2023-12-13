class CalendarsController < ApplicationController
  before_action :initialize_client, only: [:callback, :calendars, :redirect, :fetch_user_calendar_events]

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

    # Find or create the identity for the current user
    identity = current_user.identity || current_user.build_identity
    identity.update(
      provider: "google",
      access_token: response["access_token"],
      refresh_token: response["refresh_token"],
      expires_at: Time.now + response["expires_in"].to_i.seconds,
    )

    redirect_to root_path
  end

  def calendars
    @client.update!(fetch_authorization)
    service = Google::Apis::CalendarV3::CalendarService.new
    service.authorization = @client

    today = Date.today
    start_time = today.beginning_of_day.rfc3339
    end_time = today.end_of_day.rfc3339

    calendar_id = "primary"
    events = service.list_events(calendar_id, time_min: start_time, time_max: end_time)

    event_data = extract_event_data(events.items)

    render json: event_data
  end

  def logout_google_calendar
    if current_user.identity
      current_user.identity.destroy
      flash[:notice] = "Successfully logged out of Google Calendar."
    else
      flash[:alert] = "You are not logged in to Google Calendar."
    end
    redirect_to root_path 
  end

  def fetch_user_calendar_events(user)
    initialize_client
    initialize_client_for_current_user(user)
    service = Google::Apis::CalendarV3::CalendarService.new
    service.authorization = @client

    today = Date.today.in_time_zone("Central Time (US & Canada)")
    start_time = today.beginning_of_day.rfc3339
    end_time = today.end_of_day.rfc3339

    calendar_id = "primary" 
    events = service.list_events(calendar_id, time_min: start_time, time_max: end_time)

    extract_event_data(events.items)
  end

  private

  def initialize_client
    @client = Signet::OAuth2::Client.new(client_options)
  end

  def initialize_client_for_current_user(user)
    if user.identity.present?
      auth = user.identity.slice(:access_token, :refresh_token, :expires_at)
      @client.update!(auth)
    else
      # Handle the case where the user is not authenticated with Google Calendar
      raise "User has not authenticated with Google Calendar"
    end
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
    'https://symmetrical-bassoon-g4q4jq6v6j4w2pwjv-3000.app.github.dev/callback'
  end

  def fetch_authorization
    current_user.identity.refresh_token_if_expired
    current_user.identity.slice(:access_token, :refresh_token, :expires_at)
  end

  def extract_event_data(events)
    events.map do |event|
      {
        summary: event.summary,
        start_time: event.start.date_time&.in_time_zone("Central Time (US & Canada)"),
        end_time: event.end.date_time&.in_time_zone("Central Time (US & Canada)"),
      }
    end
  end
end
