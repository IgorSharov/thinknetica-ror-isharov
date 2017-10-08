# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

  concern :votable do
    resources :votes, only: :create
  end

  resources :questions, concerns: :votable do
    resources :answers, concerns: :votable do
      patch 'best_answer', on: :member
    end
  end

  resources :attachments, only: :destroy

  root to: 'questions#index'
end
