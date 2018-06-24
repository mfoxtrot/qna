Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'questions#index'

  resources :questions do
    resources :answers, shallow: true do
      member do
        post :set_as_the_best
      end
    end

    member do
      post :vote_up
      post :vote_down
      post :vote_delete
    end
  end

  resources :attachments, only: :destroy
end
