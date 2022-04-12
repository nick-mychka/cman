Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  defaults format: :json do
    # Defines the root path route ("/")
    root "welcome#index"

    resources :users, only: %i[create]

    post "/login", to: "users#login"
    get "/check_login", to: "users#check_login"

    get "/exchanges", to: "coingeckos#exchanges"

    resources :clusters, only: %i[index create update destroy] do
      resources :coin_widgets, only: %i[index create update destroy]
    end
  end
end
