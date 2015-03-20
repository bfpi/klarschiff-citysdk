class Requests::CommentsController < ApplicationController

  # Lob/Hinweis/Kritik
  #   service_request_id  pflicht  - Vorgang-ID
  #   api_key             pflicht  - API-Key
  def index
    respond_with KSBackend.comments(params[:service_request_id]), root: 'comments', dasherize: false,
      author: has_permission?(:read_comment_author)
  end

  def create

  end
end