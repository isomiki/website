Rails.application.routes.draw do
  root "pages#home"

  get "about", to: "pages#about"
  get "projects", to: "pages#projects"
  get "tools", to: "pages#tools"
  get 'tools/:name', to: 'tools#show', as: :tool
  get "contact", to: "pages#contact"
  get "posts", to: "pages#posts"
  get "posts/:name", to: "posts#show", as: :post
  get "crypto", to: "pages#crypto"
  get "misc", to: "pages#misc"

  get "not-found", to: "application#not_found"

  # Match all other paths and show not found
  match "*path", to: "application#not_found", via: :all
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
