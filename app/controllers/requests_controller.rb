class RequestsController < ApplicationController

  # Liste von Vorgängen
  # params:
  #  service_request_id  optional - Filter: Vorgangs-IDs(Kommaliste)
  #  service_code        optional - Filter: Kategorie-ID
  #  status              optional - Filter: Vorgangsstatus (Options: default=open, closed)
  #  start_date          optional - Filter: Meldungsdatum >= date
  #  end_date            optional - Filter: Meldungsdatum <= date
  #  updated_after       optional - Filter vorgang.version >= date
  #  updated_before      optional - Filter vorgang.version <= date
  #  agency_responsible  optional - Filter vorgang.auftrag.team
  #  extensions          optional - Response mit erweitereten Attributsausgaben
  def index
    filter = {}
    filter[:ids] = params[:service_request_id] unless params[:service_request_id].blank?
    filter[:category_id] = params[:service_code] unless params[:service_code].blank?
    filter[:status] = Status.const_get((params[:status] ? params[:status] : 'open').upcase).join(",")
    filter[:date_from] = (params[:start_date].to_time.to_i * 1000) unless params[:start_date].blank?
    filter[:date_to] = (params[:end_date].to_time.to_i * 1000) unless params[:end_date].blank?
    filter[:updated_from] = (params[:updated_after].to_time.to_i * 1000) unless params[:updated_after].blank?
    filter[:updated_to] = (params[:updated_before].to_time.to_i * 1000) unless params[:updated_before].blank?
    filter[:agency_responsible] = params[:agency_responsible] unless params[:agency_responsible].blank?
    logger.info "filter: #{ filter.inspect }"
    @requests = KSBackend.requests filter
    respond_with @requests, root: 'service_requests', dasherize: false, extensions: params[:extensions]
  end

  # Einzelner Vorgang nach ID
  # params:
  #  request_id          pflicht  - Vorgang-ID
  #  extensions          optional - Response mit erweitereten Attributsausgaben
  def show
    @request = KSBackend.request(params[:service_request_id])
    respond_with @request, root: 'service_requests', dasherize: false, extensions: params[:extensions]
  end

  def create

  end

  def update

  end
end
