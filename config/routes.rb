#require 'resque/server'

Rails.application.routes.draw do
  apipie
  root 'homepage#index'
  get 'regions', to: 'regions_view#index'
  get 'resources', to: 'resources_view#index'

  scope 'api' do
    resources :regions
  end
end
