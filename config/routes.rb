# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

  resources :questions do
    resources :answers do
      patch 'best_answer', on: :member
    end
  end

  resources :attachments, only: :destroy

  post '/votes/:votable_type/:votable_id/:value', to: 'votes#create', as: :vote

  root to: 'questions#index'
end
