Rails.application.routes.draw do
  devise_for :users, path_names: {
    sign_in: "login",
    sign_out: "logout",
    sign_up: "register"
  }
  get "home", to: "home#index"
  root "home#welcome"
end
