class RequestsController < ApplicationController
  skip_before_filter :validate_service_request_id, only: :index

  # Liste von Vorgängen
  # params:
  #   service_request_id  optional - Filter: Vorgangs-IDs(Kommaliste)
  #   service_code        optional - Filter: Kategorie-ID
  #   status              optional - Filter: Vorgangsstatus (Options: default=open, closed)
  #   start_date          optional - Filter: Meldungsdatum >= date
  #   end_date            optional - Filter: Meldungsdatum <= date
  #   updated_after       optional - Filter vorgang.version >= date
  #   updated_before      optional - Filter vorgang.version <= date
  #   agency_responsible  optional - Filter vorgang.auftrag.team
  #   extensions          optional - Response mit erweitereten Attributsausgaben
  def index
    filter = {}
    filter[:ids] = params[:service_request_id] unless params[:service_request_id].blank?
    filter[:category_id] = params[:service_code] unless params[:service_code].blank?
    filter[:status] = Status.for_backend(params[:status] ? params[:status].split(',') : 'open').join(',')
    filter[:date_from] = (params[:start_date].to_time.to_i * 1000) unless params[:start_date].blank?
    filter[:date_to] = (params[:end_date].to_time.to_i * 1000) unless params[:end_date].blank?
    filter[:updated_from] = (params[:updated_after].to_time.to_i * 1000) unless params[:updated_after].blank?
    filter[:updated_to] = (params[:updated_before].to_time.to_i * 1000) unless params[:updated_before].blank?
    filter[:agency_responsible] = params[:agency_responsible] unless params[:agency_responsible].blank?

    @requests = KSBackend.requests filter
    respond_with @requests, root: 'service_requests', dasherize: false, extensions: params[:extensions].try(:to_boolean)
  end

  # Einzelner Vorgang nach ID
  # params:
  #   service_request_id  pflicht  - Vorgang-ID
  #   extensions          optional - Response mit erweitereten Attributsausgaben
  def show
    @request = KSBackend.request(params[:service_request_id])
    respond_with @request, root: 'service_requests', dasherize: false, extensions: params[:extensions].try(:to_boolean)
  end

  # Neuen Vorgang anlegen
  # params:
  #   api_key             pflicht - API-Key
  #   service_code        pflicht - Kategorie
  #   email               pflicht - Autor-Email
  #   title               pflicht - Titel
  #   description         pflicht - Beschreibung
  #   location            optional - lat & long ODER address_string
  #     lat               optional - Latitude
  #     long              optional - Longitude
  #     address_string    optional - Address-String
  #   attribute           optional - Zusätzliche Attribute
  #     photo_required    optional - Fotowunsch
  #   media               optional - Foto
  def create
    request = Request.new
    request.update_attributes(params)
    request.update_service(params)

    raise request.errors_messages unless request.valid?
    backend_params = request.to_backend_params
    client = current_client(params)
    backend_params[:authCode] = client[:backend_auth_code].presence if client
    respond_with KSBackend.create_request(backend_params), dasherize: false, show_only_id: true
  end

  # Vorgang aktualisieren
  # params:
  #   api_key             pflicht  - API-Key
  #   service_request_id  pflicht  - Vorgang-ID
  #   email               pflicht  - Autor-Email
  #   service_code        optional - Kategorie
  #   title               optional - Titel
  #   description         optional - Beschreibung
  #   location            optional - lat & long ODER address_string
  #     lat               optional - Latitude
  #     long              optional - Longitude
  #     address_string    optional - Address-String
  #   attribute           optional - Zusätzliche Attribute
  #     photo_required    optional - Fotowunsch
  #     status            optional - Status (RECEIVED, IN_PROCESS, PROCESSED, REJECTED)
  #     status_comment    optional - Statuskommentar
  #     priority          optional - Priorität
  #   media               optional - Foto
  def update

  end
end
