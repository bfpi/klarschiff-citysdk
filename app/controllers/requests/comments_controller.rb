class Requests::CommentsController < ApplicationController

  # Lob/Hinweis/Kritik
  #   service_request_id  pflicht  - Vorgang-ID
  #   api_key             pflicht  - API-Key
  def index
    respond_with(KSBackend.comments(params[:service_request_id]), root: :comments, dasherize: false)
  end

  # Lob/Hinweis/Kritik anlegen
  # params:
  #   service_request_id  pflicht  - Vorgang-ID
  #   api_key             pflicht  - API-Key
  #   author              pflicht  - Autor-Email
  #   comment             pflicht  - Kommentar
  def create
    comment = Comment.new
    comment.update_attributes(params)

    backend_params = comment.to_backend_create_params
    client = current_client(params)
    backend_params[:authCode] = client[:backend_auth_code].presence if client

    respond_with(:requests, Array.wrap(KSBackend.create_comment(backend_params)), root: :comments,
                 dasherize: false, show_only_id: true, location: requests_comments_url)
  end
end