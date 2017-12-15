Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'static_pages#home'
  get 'search_channels', to: 'channels#search_channels'
  get 'newsletter', to: 'newsletters#index'
  resources :channels, only: [:show]
  
end
