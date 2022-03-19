Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  defaults format: :json do
    resources :users, only: %i[create]

    post "/login", to: "users#login"
    get '/check_login', to: 'users#check_login'
  end

  # Defines the root path route ("/")
  root "welcome#index"
end
