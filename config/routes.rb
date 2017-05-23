require 'sidekiq/web'
# require 'sidekiq-status/web'

Rails.application.routes.draw do
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get "jobs/status" => "jobs#status"

  mount Sidekiq::Web => '/sidekiq'

  root to: "admin/customers#index"
end
