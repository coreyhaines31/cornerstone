Rails.application.routes.draw do
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  get "up" => "health#up"
  get "ready" => "health#ready"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Root route
  root "pages#home"

  # Devise routes with custom controllers and clean URLs
  # Skip password routes from devise_for since we define them manually below
  devise_for :users, path: '', skip: [:passwords], controllers: {
    registrations: 'registrations',
    sessions: 'sessions'
  }, path_names: {
    sign_in: 'sign-in',
    sign_out: 'sign-out',
    sign_up: 'sign-up'
  }

  # Devise scope for additional routes
  devise_scope :user do
    # Password reset routes with clean URLs and custom controller
    get '/forgot-password', to: 'passwords#new', as: :new_user_password
    post '/forgot-password', to: 'passwords#create', as: :user_password
    get '/reset-password', to: 'passwords#edit', as: :edit_user_password
    put '/reset-password', to: 'passwords#update', as: :user_password_update

    # Magic link routes
    get '/magic-link', to: 'sessions#new_magic_link', as: :new_magic_link
    post '/magic-link', to: 'sessions#create_magic_link'
    get '/magic-link/:token', to: 'sessions#verify_magic_link', as: :verify_magic_link

    # Two-factor authentication
    get '/two-factor', to: 'sessions#new_otp', as: :new_otp
    post '/two-factor', to: 'sessions#verify_otp', as: :verify_otp
  end

  # Public pages
  get '/pricing', to: 'pages#pricing', as: :pricing
  get '/about', to: 'pages#about', as: :about
  get '/terms', to: 'pages#terms', as: :terms
  get '/privacy', to: 'pages#privacy', as: :privacy
  get '/contact', to: 'pages#contact', as: :contact
  post '/contact', to: 'pages#contact_submit', as: :contact_submit
  get '/styleguide', to: 'pages#styleguide', as: :styleguide

  # Authenticated routes
  authenticate :user do
    # Dashboard
    get '/dashboard', to: 'dashboard#show', as: :dashboard

    # User settings
    resource :settings, only: [:show, :update] do
      member do
        get :security
        post :enable_otp
        delete :disable_otp
        get :connected_accounts
      end
    end

    # Billing, team, and developer settings
    get '/billing', to: 'billing#show', as: :billing
    get '/team', to: 'team#show', as: :team
    get '/api-access', to: 'api_access#show', as: :api_access

    # Accounts
    resources :accounts do
      member do
        post :switch
        get :settings, to: 'accounts#settings', as: :settings
        patch :update_settings
      end

      # Account members
      resources :members, controller: 'account_members' do
        member do
          patch :update_role
          delete :remove
        end
      end

      # Account invitations
      resources :invitations, only: [:index, :create, :destroy] do
        member do
          post :resend
        end
      end
    end

    # Accept invitations (no authentication required for this specific route)
    get '/invitations/:token/accept', to: 'invitations#accept', as: :accept_invitation

    # Subscriptions
    resources :subscriptions, only: [:new, :create] do
      collection do
        get :success
        post :cancel
        get :billing_portal
      end
    end

    # User profile
    resource :profile, only: [:show, :edit, :update]

    # Notifications
    resources :notifications, only: [:index] do
      collection do
        post :mark_all_read
      end
      member do
        post :mark_read
      end
    end

    # Audit log
    resources :audit_events, only: [:index, :show], path: 'activity'
  end

  # Webhooks (no authentication)
  namespace :webhooks do
    post '/stripe', to: 'stripe#create'
  end

  # Admin namespace
  namespace :admin do
    root to: 'dashboard#show'

    resources :users do
      member do
        post :impersonate
        post :stop_impersonating
      end
    end

    resources :accounts
    resources :subscriptions
    resources :payments
    resources :audit_events, only: [:index, :show]
  end

  # API namespace
  namespace :api do
    namespace :v1 do
      # API authentication
      post '/auth/login', to: 'auth#login'
      post '/auth/refresh', to: 'auth#refresh'
      delete '/auth/logout', to: 'auth#logout'

      # API resources
      resources :accounts, only: [:index, :show] do
        resources :members, only: [:index]
      end
    end
  end

  # Component previews (development only)
  if Rails.env.development?
    mount Lookbook::Engine, at: "/components"
  end

  # Sidekiq web UI (admin only)
  require 'sidekiq/web'
  authenticate :user, ->(user) { user.admin? } do
    mount Sidekiq::Web => '/admin/sidekiq'
  end

  # Catch-all for 404s (must be last)
  match '*path', to: 'application#not_found', via: :all
end
