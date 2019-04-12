#require 'resque/server'

Rails.application.routes.draw do
  root 'homepage#index'
  resources :regions
#  mount Resque::Server.new, at: "/resque"
end
