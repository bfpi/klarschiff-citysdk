class Requests::NotesController < ApplicationController

  # interne Kommentare
  #   service_request_id  pflicht  - Vorgang-ID
  #   api_key             pflicht  - API-Key
  def index
    respond_with KSBackend.notes(params[:service_request_id]), root: 'notes', dasherize: false
  end

  def create

  end
end