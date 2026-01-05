Rails.application.routes.draw do
  devise_for :users, path_names: {
    sign_in: "login",
    sign_out: "logout",
    sign_up: "register"
  }
  resources :lists do
    resources :list_items do
      member do
        patch :check_switching
      end
    end

    member do
      patch :start_checking
      patch :finish_checking
      patch :back_waiting
      post :reuse
      post :to_templates
    end
  end

  resources :list_templates do
    member do
      post :to_lists
    end
  end

  get "home", to: "home#index"
  resource :mypage, only: [ :show ] do
    get :term
    get :privacy
  end

  resources :categories, only: [ :index, :destroy ]
  root "home#welcome"
end
