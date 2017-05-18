Rails.application.routes.draw do
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # match "/delayed_job" => DelayedJobWeb, :anchor => false, :via => [:get, :post]

  get "jobs/status" => "jobs#status"

  root to: "admin/customers#index"
end
