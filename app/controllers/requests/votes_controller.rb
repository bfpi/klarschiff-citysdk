class Requests::VotesController < ApplicationController

  # Meldung unterstützen
  # params:
  #   service_request_id  pflicht  - Vorgang-ID
  #   api_key             pflicht  - API-Key
  #   email               pflicht  - Autor-Email
  def create
    vote = Vote.new
    vote.update_attributes(params)

    raise vote.errors_messages unless vote.valid?
    respond_with :requests, KSBackend.create_vote(vote.to_backend_params)
  end

end
