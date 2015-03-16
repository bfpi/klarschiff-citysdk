Rails.application.routes.draw do

  get     'discovery'             => 'discovery#index'

  get     'services'              => 'services#index'
  get     'services/:service_id'  => 'services#show'

  get     'requests'              => 'requests#index'
  get     'requests/:request_id'  => 'requests#show'
  post    'requests'              => 'requests#create'
  put     'requests/:request_id'  => 'requests#update'
  patch   'requests/:request_id'  => 'requests#update'

  namespace :requests do
    post  'abuses/:request_id'    => 'abuses#create'

    get   'comments/:request_id'  => 'comments#index'
    post  'comments/:request_id'  => 'comments#create'

    get   'notes/:request_id'     => 'notes#index'
    post  'notes/:request_id'     => 'notes#create'

    post  'votes/:request_id'     => 'votes#create'
  end
end
