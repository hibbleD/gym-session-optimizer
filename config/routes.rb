Rails.application.routes.draw do
  get "dashboard/index"
  devise_for :users, controllers: { registrations: "users/registrations" }
  root "dashboard#index"
  get "/authorize", to: "google_auth#authorize"
  get "/oauth2callback", to: "google_auth#oauth2callback"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
