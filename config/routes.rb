Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }

  devise_scope :user do
    post '/sign_in_without_email', to: 'omniauth_callbacks#sign_in_without_email'
    post '/create_user_without_email', to: 'omniauth_callbacks#create_user_without_email'
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

  namespace :api do
    namespace :v1 do
      resources :profiles do
        get :me, on: :collection
      end
    end
  end

  root 'questions#index'
  mount ActionCable.server => '/cable'
end
