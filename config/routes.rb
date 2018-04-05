Rails.application.routes.draw do

  get     'areas'                        => 'areas#index'

  get     'discovery'                    => 'discovery#index'

  get     'coverage'                     => 'coverage#valid'

  get     'services'                     => 'services#index'
  get     'services/:service_id'         => 'services#show'

  get     'requests'                     => 'requests#index'
  get     'requests/:service_request_id' => 'requests#show'
  post    'requests'                     => 'requests#create'
  put     'requests/:service_request_id' => 'requests#update'
  patch   'requests/:service_request_id' => 'requests#update'

  post    'observations'                 => 'observations#create'

  namespace :requests do
    post  'abuses/:service_request_id'   => 'abuses#create', as: :abuses

    get   'comments/:service_request_id' => 'comments#index'
    post  'comments/:service_request_id' => 'comments#create', as: :comments

    post  'photos/:service_request_id'   => 'photos#create', as: :photos

    get   'notes/:service_request_id'    => 'notes#index'
    post  'notes/:service_request_id'    => 'notes#create', as: :notes

    post  'votes/:service_request_id'    => 'votes#create', as: :votes
  end
end
