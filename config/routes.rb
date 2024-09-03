Rails.application.routes.draw do

  get 'dashboard' => "site#dashboard"
  post 'generate' => "site#generate_site_url", :as => :generate_site_url
  get 'served' => "site#generated_result", :as => :generated_result
  get '/:code' => "site#short_site_url", :as => :short_site_url


  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
