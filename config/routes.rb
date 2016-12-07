Rails.application.routes.draw do
  get '/', to: 'charts#index', as: 'burnups'
  post '/', to: 'charts#create', as: 'burnups_path'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
