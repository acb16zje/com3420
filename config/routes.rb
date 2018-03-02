# frozen_string_literal: true

Rails.application.routes.draw do
  mount EpiCas::Engine, at: '/'
  devise_for :users
  resources :categories
  resources :users
  resources :bookings
  resources :items
  resources :items do
    resources :bookings
  end

  root to: 'home#index'

  match '/403', to: 'errors#error_403', via: :all
  match '/404', to: 'errors#error_404', via: :all
  match '/422', to: 'errors#error_422', via: :all
  match '/500', to: 'errors#error_500', via: :all

  get :ie_warning, to: 'errors#ie_warning'
  get :javascript_warning, to: 'errors#javascript_warning'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
