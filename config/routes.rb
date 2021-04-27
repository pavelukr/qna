Rails.application.routes.draw do
  devise_for :users
  resources :questions do
    resources :answers do
      patch :select_best
    end
  end

  root 'questions#index'
end
