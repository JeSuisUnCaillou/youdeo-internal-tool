Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'static_pages#home'
  post 'search_channels', to: 'channels#search_channels'
  resources :channels, only: [:show]
  
end
