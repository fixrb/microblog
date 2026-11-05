# frozen_string_literal: true

Rails.application.routes.draw do
  root "timelines#show"

  resource :session, only: %i[new create destroy]
  resources :posts, only: :create

  resources :users, only: :show, param: :handle do
    resource :follow, only: %i[create destroy]
  end
end
