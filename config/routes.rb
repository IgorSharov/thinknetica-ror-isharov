# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

  concern :votable do
    resources :votes, only: :create
  end

  resources :questions, concerns: :votable, shallow: true do
    resources :answers, concerns: :votable, only: %i[create update destroy] do
      patch 'best', on: :member
    end
  end

  resources :attachments, only: :destroy

  root to: 'questions#index'

  mount ActionCable.server, at: '/cable'
end
