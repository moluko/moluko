Moluko::Application.routes.draw do
  #user sessions
  match 'getstarted' => 'pages#getstarted'
  match 'logout' => 'user_sessions#destroy'
  match 'dashboard' => 'pages#dashboard'
  match 'bulk_import' => 'bulk_import#index'
  match 'csv_import' => 'bulk_import#csv'
  match 'all_user_histories' => 'user_histories#all_user_histories'
  match 'all_shop_histories' => 'shop_histories#all_shop_histories'

  resources :products do
    collection do
      post :sort
    end
  end

  resources :checkout_notifications

  resources :countries

  resources :themes do
    resources :theme_pages
    collection do
      post :sort
    end
  end

  resources :categories do
    collection do
      post :sort
    end
  end

  resources :sales do
    member do
      post :update_shipping_status
    end
  end

  resources :shipping_plans do
    collection do
      post :create_using_csv
    end
  end

  resources :shops do
    resources :shop_histories
    member do
      get :payment
      get :switch_shop
      get :switch_theme
      get :themes
      put :update_payment
    end
  end

  #facebook
  namespace :facebook do
    resources :page do
      collection do
        get :close
      end
      member do
        get :show_cart
        get :show_add_to_cart_dialog
        get :add_to_cart
        get :delete_cart_item
        get :show_calculate_shipping_dialog
        get :calculate_shipping
      end
    end
  end

  #public
  resources :password_resets
  resources :user_sessions
  resources :users do
    resources :user_histories
  end

  match 'login' => 'user_sessions#new'
  root :to => 'user_sessions#new'
end
