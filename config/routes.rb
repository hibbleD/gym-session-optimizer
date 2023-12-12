Rails.application.routes.draw do
  get "dashboard/index"
  devise_for :users, controllers: { registrations: "users/registrations" }
  root "dashboard#index"
  get "/redirect", to: "calendars#redirect"
  get "/callback", to: "calendars#callback"
  get "/calendars", to: "calendars#calendars"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
