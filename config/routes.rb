Rails.application.routes.draw do
  devise_for :users, path_names: {
    sign_in: "login",
    sign_out: "logout",
    sign_up: "register"
  }
  resources :lists do
    resources :list_items, only: [ :create, :update, :destroy ]
    member do
      patch :start_checking
      patch :finish_checking
      patch :back_waiting
      post :reuse
    end
  end
  get "home", to: "home#index"
  root "home#welcome"
end
