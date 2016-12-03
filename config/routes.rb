Rails.application.routes.draw do
  get '/', to: 'charts#index', as: 'charts'
  post '/', to: 'charts#create', as: 'charts_create'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
