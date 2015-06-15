class RequestsController < ApplicationController
  skip_before_filter :validate_service_request_id, only: :index

  # Liste von Vorgängen
  # params:
  #   api_key             optional - API-Key
  #   service_request_id  optional - Filter: Vorgangs-IDs(Kommaliste)
  #   service_code        optional - Filter: Kategorie-ID
  #   status              optional - Filter: Vorgangsstatus (Options: default=open, closed)
  #   detailed_status     optional - Filter: Vorgangsstatus (Options: PENDING, RECEIVED, IN_PROCESS, PROCESSED, REJECTED)
  #   start_date          optional - Filter: Meldungsdatum >= date
  #   end_date            optional - Filter: Meldungsdatum <= date
  #   updated_after       optional - Filter vorgang.version >= date
  #   updated_before      optional - Filter vorgang.version <= date
  #   agency_responsible  optional - Filter vorgang.auftrag.team
  #   extensions          optional - Response mit erweitereten Attributsausgaben
  #   lat                 optional - Schränkt den Bereich ein, in dem gesucht wird (benötigt: lat, long und radius)
  #   long                optional - Schränkt den Bereich ein, in dem gesucht wird (benötigt: lat, long und radius)
  #   radius              optional - Schränkt den Bereich ein, in dem gesucht wird (benötigt: lat, long und radius)
  def index
    filter = {}
    filter[:ids] = params[:service_request_id] unless params[:service_request_id].blank?
    filter[:category_id] = params[:service_code] unless params[:service_code].blank?
    filter[:status] = Status.open311_for_backend(params[:status] ? params[:status].split(/, ?/) : 'open').join(',')
    filter[:status] = Status.citysdk_for_backend(params[:detailed_status].split(/, ?/)) unless params[:detailed_status].blank?
    filter[:date_from] = (params[:start_date].to_time.to_i * 1000) unless params[:start_date].blank?
    filter[:date_to] = (params[:end_date].to_time.to_i * 1000) unless params[:end_date].blank?
    filter[:updated_from] = (params[:updated_after].to_time.to_i * 1000) unless params[:updated_after].blank?
    filter[:updated_to] = (params[:updated_before].to_time.to_i * 1000) unless params[:updated_before].blank?
    filter[:agency_responsible] = params[:agency_responsible] unless params[:agency_responsible].blank?
    filter[:negation] = params[:negation] unless params[:negation].blank?
    if params[:lat] && params[:long] && params[:radius]
      filter[:restriction_area] = "ST_GeomFromText(ST_AsText(ST_Buffer(geography('POINT(#{ params[:lat] } #{ params[:long] })'), #{ params[:radius] })))"
    end

    @requests = KSBackend.requests filter
    respond_with(@requests, root: :service_requests, dasherize: false,
      extensions: params[:extensions].try(:to_boolean), job_details: has_permission?(:request_job_details))
  end

  # Einzelner Vorgang nach ID
  # params:
  #   service_request_id  pflicht  - Vorgang-ID
  #   api_key             optional - API-Key
  #   extensions          optional - Response mit erweitereten Attributsausgaben
  def show
    @request = KSBackend.request(params[:service_request_id])
    respond_with(@request, root: :service_requests,
                 dasherize: false, extensions: params[:extensions].try(:to_boolean),
                 job_details: has_permission?(:request_job_details))
  end

  # Neuen Vorgang anlegen
  # params:
  #   api_key             pflicht - API-Key
  #   service_code        pflicht - Kategorie
  #   email               pflicht - Autor-Email
  #   title               pflicht - Titel
  #   description         pflicht - Beschreibung
  #   lat                 optional - Latitude & Longitude ODER Address-String
  #   long                optional - Latitude & Longitude ODER Address-String
  #   address_string      optional - Latitude & Longitude ODER Address-String
  #   photo_required      optional - Fotowunsch
  #   media               optional - Foto (Base64-Encoded-String)
  def create
    request = Request.new
    default_title = params[:description].try(:truncate, 60, separator: ' ')
    request.update_attributes({ title: default_title }.merge(params))
    request.update_service(params)

    raise request.errors_messages unless request.valid?
    backend_params = request.to_backend_create_params
    client = current_client(params)
    backend_params[:authCode] = client[:backend_auth_code].presence if client
    respond_with(Array.wrap(KSBackend.create_request(backend_params)), root: :service_requests, location: requests_url,
                 dasherize: false, show_only_id: true)
  end

  # Vorgang aktualisieren
  # params:
  #   api_key             pflicht  - API-Key
  #   service_request_id  pflicht  - Vorgang-ID
  #   email               pflicht  - Autor-Email
  #   service_code        optional - Kategorie
  #   title               optional - Titel
  #   description         optional - Beschreibung
  #   lat                 optional - Latitude & Longitude ODER Address-String
  #   long                optional - Latitude & Longitude ODER Address-String
  #   address_string      optional - Latitude & Longitude ODER Address-String
  #   photo_required      optional - Fotowunsch
  #   media               optional - Foto (Base64-Encoded-String)
  #   detailed_status     optional - Status (RECEIVED, IN_PROCESS, PROCESSED, REJECTED)
  #   status_notes        optional - Statuskommentar
  #   priority            optional - Priorität
  #   delegation          optional - Delegation
  #   job_status          optional - Auftrag-Status
  #   job_priority        optional - Auftrag-Priorität
  def update
    request = KSBackend.request(params[:service_request_id]).first
    request.update_attributes(params)
    request.update_service(params)

    backend_params = request.to_backend_update_params
    client = current_client(params)
    backend_params[:authCode] = client[:backend_auth_code].presence if client

    response_object = Array.wrap(KSBackend.update_request(backend_params))
    respond_with(response_object, root: :service_requests, location: requests_url,
                 dasherize: false, show_only_id: true, params[:format].to_sym => response_object)
  end
end
