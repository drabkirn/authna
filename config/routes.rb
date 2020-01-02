Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root 'ui/leaves#index'

  # For react UI requests
  match '*path', to: 'ui/leaves#index', via: :all
end
