Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    # Defines the root path route ("/")
    root "static_pages#home"

    get "static_pages/home"
    get "static_pages/help"

    get "/signup", to: "users#new"
    post "/signup", to: "users#create"
    resources :users, only: %i(new create show)

  end
end
