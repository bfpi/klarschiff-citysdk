class Requests::VotesController < ApplicationController

  # Meldung unterstützen
  # params:
  #   service_request_id              pflicht  - Vorgang-ID
  #   author                          pflicht  - Autor-Email
  #   privacy_policy_accepted         optional - Bestätigung Datenschutz
  #   status_updates_for_supporter    optional - Über Statusänderungen informieren
  def create
    vote = Vote.new
    vote.assign_attributes(params)

    respond_with(:requests, Array.wrap(KSBackend.create_vote(vote.to_backend_params)), root: :votes,
                 location: requests_votes_url)
  end

end
