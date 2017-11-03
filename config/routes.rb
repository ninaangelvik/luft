Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'home#index'

  post '/upload', to: 'datafiles#create'
  get '/download', to: 'home#download'
  get 'files', to: 'datafiles#index'
  get 'files/get_id', to: 'datafiles#get_id'
  get 'files/get_data', to: 'datafiles#get_data'
  get '/_ah/health', to: 'home#health'
  get '/download', to: 'weather_data#download'
  get '/get_data', to: 'weather_data#get_data'

  resource :datafiles, only:[:create]
end
