Rails.application.routes.draw do

  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config

  root :to => "users#new"

  post 'users/create' => 'users#create'
  get 'users/index' => 'users#index'

#  get 'refer-a-friend' => 'users#refer'
  get 'thank-you' => 'users#thankyou'

#  resources :quiz, only: [:index]
#  get "/quiz/:results_id", to: "quiz#index", as: "results_id"

  get 'results' => 'users#results'

  get 'upcoming-webinars' => 'users#upcomingwebinars'

  unless Rails.application.config.consider_all_requests_local
      get '*not_found', to: 'users#redirect', :format => false
  end
  
end
