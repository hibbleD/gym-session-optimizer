Rails.application.routes.draw do
  root "dashboard#index"
  devise_for :users, controllers: { registrations: "user/registrations" }
  get "dashboard/index"
  get "dashboard/recommend_time", to: "dashboard#recommend_time", as: "recommend_time"

  # Google Calendar OAuth routes
  get "/redirect", to: "calendars#redirect", as: :login_google_calendar
  get "/callback", to: "calendars#callback"
  get "/calendars", to: "calendars#calendars"

  get "/logout_google_calendar", to: "calendars#logout_google_calendar", as: :logout_google_calendar
end
