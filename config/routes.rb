Rails.application.routes.draw do
  
  match 'mediator_form' , to: 'mediators#mediator', via: [:get, :post], as: 'mediator_mediator'
  
  resources :mediators
    root 'mediators#new'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
