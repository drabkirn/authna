Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root 'ui/leaves#index'

  devise_for :users, controllers: {confirmations: 'api/v1/confirmations', omniauth_callbacks: 'api/v1/omniauth_callbacks'}, skip: [:sessions, :password, :registrations]

  namespace :api, defaults: { format: :json }, path: '/', constraints: ApiRequestCheck.new do
    scope module: :v1 do
      post 'auth/login', to: 'authentication#authenticate'
      
      post 'auth/signup', to: 'users#create'

      post 'auth/enable2fa', to: 'multi_factor_authentication#verify_enable'
      post 'auth/disable2fa', to: 'multi_factor_authentication#verify_disabled'

      post 'auth/password/forgot', to: 'passwords#forgot'
      post 'auth/password/recover', to: 'passwords#recover'
    end
  end

  # When making invalid API-only requests, show 404 and 500
  match "/404", to: "application#action_not_found", via: [:all]
  match "/500", to: "application#internal_server_error", via: [:all]

  # For react UI requests
  match '*path', to: 'ui/leaves#index', via: :all, constraints: UiRequestCheck.new
end
