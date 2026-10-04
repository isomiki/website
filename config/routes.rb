Rails.application.routes.draw do
  root "pages#home"

  get "summary", to: "pages#summary"
  get "projects", to: "pages#projects"
  get "tools", to: "pages#tools"
  get 'tools/:name', to: 'tools#show', as: :tool
  get "contact", to: "pages#contact"
  get "posts", to: "pages#posts"
  get "posts/:name", to: "posts#show", as: :post

  get "rss", to: "feeds#show", defaults: { format: "rss" }, as: :rss_feed
  get "feed", to: "feeds#show", defaults: { format: "rss" }, as: :feed
  get "crypto", to: "pages#crypto"
  
  get "misc", to: "pages#misc"
  get 'm/:page', to: 'pages#miscpage'
  
  get "test", to: "pages#test"

  get "not-found", to: "application#not_found"

  match "*path", to: "application#not_found", via: :all

  get "up" => "rails/health#show", as: :rails_health_check
end
