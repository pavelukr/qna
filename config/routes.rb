Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' } do
    post '/sign_in_twitter', to: 'omniauth_callbacks#sign_in_twitter'
    post 'sign_in_twitter', to: 'omniauth_callbacks#sign_in_twitter'
    post '/sign_in_twitter.user', to: 'omniauth_callbacks#sign_in_twitter'
    post '/sign_in_twitter/', to: 'omniauth_callbacks#sign_in_twitter'
  end

  devise_scope :user do
    post '/sign_in_twitter', to: 'omniauth_callbacks#sign_in_twitter'
    post '/sign_in_twitter.user', to: 'omniauth_callbacks#sign_in_twitter'
    post '/sign_in_twitter/', to: 'omniauth_callbacks#sign_in_twitter'
  end

  concern :voted do
    post :like, :dislike
    delete :unvote
  end

  concern :commented do
    post :create_comment
    delete :delete_comment
  end

  post '/', to: proc { [200, {}, ['']] }
  post '/questions/10', to: proc { [200, {}, ['']] }
  delete '/', to: proc { [200, {}, ['']] }

  resources :questions, concerns: [:voted, :commented] do
    patch :delete_attachment
    resources :answers, concerns: [:voted, :commented] do
      patch :select_best
      patch :delete_attachment
    end
  end

  root 'questions#index'
  mount ActionCable.server => '/cable'
end
