# frozen_string_literal: true

Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  resources :moderators, only: %i[index]

  devise_for :users

  root 'posts#index'

  resources :users

  resources :posts, only: %i[index show new create] do
    member do
      post :suggestions
      post :like
      delete :like_destroy
      post :report
      delete :report_destroy
      get :approved
      get :rejected
    end

    collection do
      get :pending
      get :reported
      get :myrejected
    end

    resources :likes, only: %i[create destroy]
    resources :comments do
      member do
        post :like
        delete :like_destroy
        post :report
        delete :report_destroy
        post :reply
      end
    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
