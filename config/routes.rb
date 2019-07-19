Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :shortcuts
  root to: 'shortcuts#index'
  get '/:id', to: 'shortcuts#show', constraints: { id: /[0-9a-z]{1,8}/ }
end
