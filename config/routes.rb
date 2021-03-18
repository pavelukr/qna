Rails.application.routes.draw do
  devise_for :users
  resources :questions do
    patch :delete_attachment
    resources :answers do
      patch :select_best
      patch :delete_attachment
    end
  end

  root 'questions#index'
end
