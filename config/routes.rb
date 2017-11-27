# frozen_string_literal: true

Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }

  devise_scope :user do
    post 'omniauth_callbacks/email_confirm_for_oauth'
  end

  concern :votable do
    resources :votes, only: :create
  end

  concern :commentable do
    resources :comments, only: :create
  end

  resources :questions, concerns: %i[commentable votable], shallow: true do
    resources :answers, concerns: %i[commentable votable], only: %i[create update destroy] do
      patch 'best', on: :member
    end
  end

  resources :attachments, only: :destroy

  root to: 'questions#index'

  mount ActionCable.server, at: '/cable'

  namespace :api do
    namespace :v1 do
      resource :profiles do
        get :me, on: :collection
      end
    end
  end
end
