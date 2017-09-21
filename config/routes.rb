Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'home#index'

  post 'home/upload'
  get 'home/download'
  get 'files', to: 'datafiles#index'
  get 'files/get_id', to: 'datafiles#get_id'
  get 'files/get_data', to: 'datafiles#get_data'
  get '/_ah/health', to: 'home#health'

  resource :datafiles, only:[:create]
end
