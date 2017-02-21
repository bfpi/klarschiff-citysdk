class ObservationsController < ApplicationController
  
  # Neue Beobachtungsfläche anlegen
  # params:
  #   area_code         optional - IDs der Stadtteilgrenze (-1 für Stadtgrenze)
  #   geometry          optional - Geometrie einer erstellten Fläche als WKT
  #   problems          optional - Probleme überwachen
  #   problem_service   optional - IDs ausgewählter Hauptkategorien für Probleme
  #   ideas             optional - Ideen überwachen
  #   idea_service      optional - IDs ausgwählte Hauptkategorien für Ideen
  def create
    observation = Observation.new
    observation.assign_attributes params
    obj = Array.wrap(KSBackend.create_observation(observation.to_backend_params))
  end
end
