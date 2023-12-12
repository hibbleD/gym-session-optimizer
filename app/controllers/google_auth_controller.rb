require 'google/apis/calendar_v3'
require 'googleauth'
require 'googleauth/stores/file_token_store'
require 'googleauth/web_user_authorizer'

class GoogleAuthController < ApplicationController
  OOB_URI = 'https://symmetrical-bassoon-g4q4jq6v6j4w2pwjv-3000.app.github.dev/oauth2callback'
  CLIENT_SECRETS_PATH = 'client_secret.json'
  CREDENTIALS_PATH = File.join(Dir.home, '.credentials', "calendar-ruby-quickstart.yaml")
  SCOPE = Google::Apis::CalendarV3::AUTH_CALENDAR_READONLY

  def authorize
    authorizer = Google::Auth::WebUserAuthorizer.new(
      Google::Auth::ClientId.from_file(CLIENT_SECRETS_PATH),
      SCOPE,
      Google::Auth::Stores::FileTokenStore.new(file: CREDENTIALS_PATH))
  
    user_id = 'default'
    credentials = authorizer.get_credentials(user_id, request)
    if credentials.nil?
      redirect_to authorizer.get_authorization_url(base_url: OOB_URI, request: request)
    else
      # Save the credentials to the session or database here
  
      # Initialize the Google Calendar API client service
      service = Google::Apis::CalendarV3::CalendarService.new
      service.authorization = credentials
  
      # Now you can use `service` to make requests to the Google Calendar API
    end
  end

  def oauth2callback
    target_url = Google::Auth::WebUserAuthorizer.handle_auth_callback_deferred(request)
    redirect_to target_url
  end
end
