Rails.application.routes.draw do

  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks', registrations: 'users/registrations' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'questions#index'
  post 'search/find'

  concern :votable do
    member do
      post :vote_up
      post :vote_down
      delete :vote_delete
    end
  end

  concern :commentable do
    member do
      post :create_comment
    end
  end

  resources :questions, concerns: [:votable, :commentable], defaults: { commentable: 'question'} do
    resources :subscriptions, only: [:create, :destroy], shallow: true
    resources :answers, concerns: [:votable, :commentable], defaults: { commentable: 'answer'}, shallow: true do
      member do
        post :set_as_the_best
      end
    end
  end

  resources :attachments, only: :destroy

  mount ActionCable.server => '/cable'

  namespace :api do
    namespace :v1 do
      resource :profiles do
        get :me, on: :collection
        get :list, on: :collection
      end

      resources :questions, only: [:index, :show, :create] do
        resources :answers, only: [:index, :show, :create], shallow: true
      end
    end
  end
end
