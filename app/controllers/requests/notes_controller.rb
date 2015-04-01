class Requests::NotesController < ApplicationController

  # interne Kommentare
  #   service_request_id  pflicht  - Vorgang-ID
  #   api_key             pflicht  - API-Key
  def index
    respond_with(KSBackend.notes(params[:service_request_id]), root: :notes, dasherize: false)
  end

  # internen Kommentar anlegen
  # params:
  #   service_request_id  pflicht  - Vorgang-ID
  #   api_key             pflicht  - API-Key
  #   author              pflicht  - Autor-Email
  #   comment             pflicht  - Kommentar
  def create
    note = Note.new
    note.update_attributes(params)

    backend_params = note.to_backend_create_params
    client = current_client(params)
    backend_params[:authCode] = client[:backend_auth_code].presence if client

    respond_with(:requests, Array.wrap(KSBackend.create_note(backend_params)), root: :notes,
                 dasherize: false, show_only_id: true, location: requests_notes_url)
  end
end