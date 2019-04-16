#require 'resque/server'

Rails.application.routes.draw do
  apipie
  root 'homepage#index'

  get 'regions', to: 'regions_view#index'
  get 'regions/simulator', to: 'regions_view#simulator'
  post 'regions/simulator', to: 'regions_view#simulator_submit'
  get 'regions/simulator/:id', to: 'regions_view#simulator_byregion'
  get 'regions/:id', to: 'regions_view#show'
  get 'resources', to: 'resources_view#index'

  scope 'api' do
    resources :regions
  end
end
