class JobsController < ApplicationController
  skip_before_action :validate_status

  # Neuen Auftrag anlegen
  # params:
  #   api_key             pflicht - API-Key
  #   date                pflicht - Datum
  #   status              optional - Status
  def index
    filter = {}
    filter[:date] = (params[:date].to_time.to_i * 1000) unless params[:date].blank?
    filter[:status] = status(params[:status]) unless params[:status].blank?

    @jobs = KSBackend.jobs(params[:api_key] ? backend_params(filter) : filter)
    respond_with @jobs, root: :jobs, dasherize: false
  end

  # Neuen Auftrag anlegen
  # params:
  #   api_key             pflicht - API-Key
  #   service_request_id  pflicht - Vorgang-ID
  #   agency_responsible  pflicht - Außendienst-Team
  #   date                pflicht - Datum
  def create
    job = Job.new
    job.assign_attributes params.slice(:service_request_id, :agency_responsible, :date)

    raise job.errors_messages unless job.valid?

    obj = Array.wrap(KSBackend.create_job(backend_params(job.to_backend_create_params)))
    respond_with obj, root: :jobs, location: jobs_url, dasherize: false
  end

  # Auftrag aktualisieren
  # params:
  #   api_key             pflicht - API-Key
  #   service_request_id  pflicht - Vorgang-ID
  #   status              pflicht - Status (CHECKED, UNCHECKED, NOT_CHECKABLE)
  #   date                pflicht - Datum
  def update
    job = Job.new
    job.assign_attributes params.slice(:service_request_id, :date, :status)

    raise job.errors_messages unless job.valid?

    obj = Array.wrap(KSBackend.update_job(backend_params(job.to_backend_update_params)))
    respond_with do |format|
      format.xml { render xml: obj}
      format.json { render json: obj}
    end
  end

  private
  def status(value)
    case value
      when "UNCHECKED"
        "nicht_abgehakt"
      when "CHECKED"
        "abgehakt"
      when "NOT_CHECKABLE"
        "nicht_abarbeitbar"
    end
  end
end
