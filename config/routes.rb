Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'questions#index'

  resources :questions, only: [:index, :show, :new, :create, :destroy] do
    resources :answers, only: [:new, :create, :destroy], shallow: true
  end
end
