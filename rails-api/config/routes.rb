# frozen_string_literal: true

# @see https://guides.rubyonrails.org/routing.html

require 'sidekiq/web'

# Configure Sidekiq-specific session middleware
# @see https://edgeguides.rubyonrails.org/api_app.html#using-session-middlewares
Sidekiq::Web.use ActionDispatch::Cookies
Sidekiq::Web.use ActionDispatch::Session::CookieStore, key: '_interslice_session'

Rails.application.routes.draw do
  # Implemented because this is a Sidekiq rack app, not handled by Devise and
  # the Nuxt front end.
  # @see https://github.com/mperham/sidekiq/issues/4061
  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    credentials = Rails.application.credentials.dig(:sidekiq, :basic_auth)
    ActiveSupport::SecurityUtils.secure_compare(username, credentials[:username]) &&
      ActiveSupport::SecurityUtils.secure_compare(password, credentials[:password])
  end

  # Accessed at https://gef-spatial-api.web-supported-staging.linode.unep-wcmc.org/sidekiq
  mount Sidekiq::Web => '/sidekiq'

  namespace :v1 do
    mount ActionCable.server => '/cable'

    devise_for :users,
      as: :v1,
      path: 'auth',
      controllers: {
        confirmations: 'v1/users/confirmations',
        # omniauth_callbacks: 'v1/users/omniauth_callbacks',
        passwords: 'v1/users/passwords',
        registrations: 'v1/users/registrations',
        sessions: 'v1/users/sessions',
        unlocks: 'v1/users/unlocks'
      }
    get 'auth/user', to: 'users/current_user#show'
    resources :users
    resources :gef_projects, only: %i[index show destroy update] do
      resource :shapefile, only: %i[show create update destroy]
      resources :import_errors, only: [:index]
    end
    resources :sync, only: [:create]
    get 'last_sync', to: 'last_sync#show'
    resources :charts, only: [:show]
    resources :portfolios, only: [:index]

    namespace :geoserver do
      resources :shapefiles, only: %i[update]
    end

    namespace :portfolio do
      resources :focal_areas, only: %i[index]
      resources :georegions, only: %i[index]
      resources :users, only: %i[index]
      resources :date_ranges, only: %i[index]
    end

    namespace :geospatial_layers do
      resources :gef_projects, only: %i[index show] do
        resources :indicators, only: %i[index]
      end
    end

    resources :indicators, only: [] do
      resources :spatial_datasets, only: [:index]
    end

    resources :focal_areas, only: [] do
      resources :spatial_datasets, only: [:index]
    end
  end
end
