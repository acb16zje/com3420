Rails.application.routes.draw do
  resources :user_home_categories
  mount EpiCas::Engine, at: '/'
  devise_for :users

  resources :categories do
    get 'filter', on: :collection
  end

  resources :users do
    get 'manager', on: :collection
  end

  resources :bookings do
    get 'requests', on: :collection
    get 'accepted', on: :collection
    get 'ongoing', on: :collection
    get 'completed', on: :collection
    get 'rejected', on: :collection
    get 'late', on: :collection

    put 'set_booking_returned', on: :member
    put 'set_booking_cancelled', on: :member
  end

  resources :items do
    resources :bookings do
      get 'start_date', on: :collection
      get 'end_date', on: :collection
    end
    get 'add_peripheral_option', on: :member
    get 'choose_peripheral', on: :member
    post 'add_peripheral', on: :member
    get 'manager', on: :collection
    put 'update_manager_multiple', on: :collection
    post 'change_manager_multiple', on: :collection
    get 'set_condition', on: :member
    put 'update_condition', on: :member
  end

  resources :notifications do
    collection do
      post :mark_as_read
    end
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
