class Requests::PhotosController < ApplicationController

  # Foto hinzufügen
  # params:
  #   service_request_id  pflicht  - Vorgang-ID
  #   author              pflicht  - Autor-Email
  def create
    photo = Photo.new
    photo.assign_attributes(params)

    respond_with(:requests, Array.wrap(KSBackend.create_photo(photo.to_backend_create_params)), root: :photos,
                 dasherize: false, show_only_id: true, location: requests_photos_url)
  end
end
