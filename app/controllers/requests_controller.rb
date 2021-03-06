class RequestsController < ApplicationController
  skip_before_action :validate_service_request_id, only: :index
  before_action :encode_params, only: [:create, :update]


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
  #   keyword             optional - Filter: Meldungstyp (Problem|Idee|Tipp)
  #   max_requests        optional - Anzahl der neuesten Meldungen
  #   also_archived       optional - Filter: Auch Archivierte Meldungen berücksichtigen
  #   just_count          optional - es soll nur die Anzahl der Meldungen zurückgegeben werden
  #   observation_key     optional - MD5-Hash der zugehörigen Beobachtungsfläche
  #   with_photo          optional - Filter: Meldungen mit freigegebenen Fotos
  def index
    filter = {}
    filter[:ids] = params[:service_request_id] unless params[:service_request_id].blank?
    filter[:category_id] = params[:service_code] unless params[:service_code].blank?
    filter[:status] = Status.open311_for_backend(params[:status] ? params[:status].split(/, ?/) : 'open').join(',')
    filter[:status] = Status.citysdk_for_backend(params[:detailed_status].split(/, ?/)).presence || '' unless params[:detailed_status].nil?
    filter[:date_from] = (params[:start_date].to_time.to_i * 1000) unless params[:start_date].blank?
    filter[:date_to] = (params[:end_date].to_time.to_i * 1000) unless params[:end_date].blank?
    filter[:updated_from] = (params[:updated_after].to_time.to_i * 1000) unless params[:updated_after].blank?
    filter[:updated_to] = (params[:updated_before].to_time.to_i * 1000) unless params[:updated_before].blank?
    filter[:agency_responsible] = params[:agency_responsible] unless params[:agency_responsible].blank?
    filter[:negation] = params[:negation] unless params[:negation].blank?
    filter[:typ] = Request.city_sdk_keywords_for_backend(params[:keyword].split(/, ?/)).presence || '' unless params[:keyword].nil?
    filter[:max_requests] = params[:max_requests] unless params[:max_requests].blank?
    filter[:geoRssHash] = params[:observation_key] unless params[:observation_key].blank?
    filter[:also_archived] = params[:also_archived] unless params[:also_archived].blank?
    filter[:just_count] = params[:just_count] unless params[:just_count].blank?
    filter[:area_code] = params[:area_code] unless params[:area_code].blank?
    if params[:lat] && params[:long] && params[:radius]
      filter[:restriction_area] = "CAST(ST_Buffer(CAST(ST_SetSRID(ST_MakePoint(#{ params[:lat] }, #{ params[:long] }), 4326) AS geography), #{ params[:radius] }) AS geometry)"
    end
    filter[:with_foto] = params[:with_picture].to_boolean unless params[:with_picture].blank?

    @requests = KSBackend.requests(params[:api_key] ? backend_params(filter) : filter)
    respond_with @requests, root: :service_requests, dasherize: false,
      extensions: params[:extensions].try(:to_boolean), property_details: has_permission?(:request_property_details), job_details: has_permission?(:request_job_details)
  end

  # Einzelner Vorgang nach ID
  # params:
  #   service_request_id  pflicht  - Vorgang-ID
  #   api_key             optional - API-Key
  #   extensions          optional - Response mit erweitereten Attributsausgaben
  def show
    @request = KSBackend.request(params[:service_request_id], params[:api_key] ? backend_params({ also_archived: true }) : {})
    respond_with @request, root: :service_requests, dasherize: false,
      extensions: params[:extensions].try(:to_boolean),
      property_details: has_permission?(:request_property_details),
      job_details: has_permission?(:request_job_details)
  end

  # Neuen Vorgang anlegen
  # params:
  #   api_key                   pflicht - API-Key
  #   service_code              pflicht - Kategorie
  #   email                     pflicht - Autor-Email
  #   description               pflicht - Beschreibung
  #   lat                       optional - Latitude & Longitude ODER Address-String
  #   long                      optional - Latitude & Longitude ODER Address-String
  #   address_string            optional - Latitude & Longitude ODER Address-String
  #   photo_required            optional - Fotowunsch
  #   media                     optional - Foto (Base64-Encoded-String)
  #   privacy_policy_accepted   optional - Bestätigung Datenschutz
  def create
    request = Request.new
    request.assign_attributes params.slice(:email, :service_code, :description, :lat, :long,
                                           :address_string, :photo_required, :media, :privacy_policy_accepted)

    raise request.errors_messages unless request.valid?

    obj = Array.wrap(KSBackend.create_request(backend_params(
      request.to_backend_create_params)))
    respond_with obj, root: :service_requests, location: requests_url,
      dasherize: false, show_only_id: true
  end

  # Vorgang aktualisieren
  # params:
  #   api_key             pflicht  - API-Key
  #   service_request_id  pflicht  - Vorgang-ID
  #   email               pflicht  - Autor-Email
  #   service_code        optional - Kategorie
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
    request = KSBackend.request(params[:service_request_id], params[:api_key] ? backend_params({}) : {}).first
    if status = params[:detailed_status].presence
      unless status.in?(Status::PERMISSABLE_CITY_SDK_KEYS | [request.detailed_status])
        request.errors.add :detailed_status,
          I18n.t("activemodel.errors.models.request.attributes.detailed_status.forbidden")
        raise request.errors_messages
      end
    end
    request.assign_attributes params.slice(:email, :service_code, :description, :lat, :long,
                                           :address_string, :photo_required, :media,
                                           :detailed_status, :status_notes, :priority,
                                           :delegation, :job_status, :job_priority)

    obj = Array.wrap(KSBackend.update_request(backend_params(
      request.to_backend_update_params)))
    respond_with obj, root: :service_requests, location: requests_url,
      dasherize: false, show_only_id: true, params[:format].to_sym => obj
  end

  private

  def encode_params
    params.each do |k, v|
      if k.in? %w(email description address_string status_notes delegation)
        params[k] = v.force_encoding("ISO-8859-1").encode("UTF-8") unless v.is_utf8?
      end
    end
  end
end
