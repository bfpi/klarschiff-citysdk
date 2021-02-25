class Requests::AbusesController < ApplicationController

  # Missbrauch melden
  # params:
  #   service_request_id        pflicht  - Vorgang-ID
  #   author                    pflicht  - Autor-Email
  #   comment                   pflicht  - Kommentar
  #   privacy_policy_accepted   optional - Bestätigung Datenschutz
  def create
    abuse = Abuse.new
    abuse.assign_attributes(params)

    respond_with(:requests, Array.wrap(KSBackend.create_abuse(abuse.to_backend_create_params)), root: :abuses,
                 dasherize: false, show_only_id: true, location: requests_abuses_url)
  end
end
