Rails.application.routes.draw do
  devise_for :users

  concern :voted do
    post :like, :dislike
    resources :votes, only: :destroy
  end


  resources :questions, concerns: :voted do
    patch :delete_attachment
    resources :answers, concerns: :voted do
      patch :select_best
      patch :delete_attachment
    end
  end

  root 'questions#index'
end
