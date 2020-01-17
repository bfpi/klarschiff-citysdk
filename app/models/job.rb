class Job
  include ActiveModel::AttributeMethods
  include DateFormatter
  include CitySDKSerialization
  include ValidationErrorFormatter

  attr_accessor :id, :vorgang_id, :team, :auftragDatum, :auftragStatus
  self.serialization_attributes = [:id, :service_request_id, :date, :agency_responsible, :status]

  alias_attribute :date, :auftragDatum
  alias_attribute :service_request_id, :vorgang_id
  alias_attribute :agency_responsible, :team

  def to_backend_create_params
    {
      date: auftragDatum,
      status: auftragStatus
    }
  end

  def to_backend_create_params
    {
      vorgang_id: vorgang_id,
      agency_responsible: team,
      date: auftragDatum,
    }
  end

  def to_backend_update_params
    {
      vorgang_id: vorgang_id,
      date: auftragDatum,
      status: auftragStatus
    }
  end

  def datum=(value)
    @auftragDatum = value
  end

  def date=(value)
    @auftragDatum = Date.parse(value).to_time.to_i * 1000 unless value.blank?
  end

  def date
    format_date(auftragDatum)
  end

  def service_request_id=(value)
    @vorgang_id = value
  end

  def agency_responsible=(value)
    @team = value
  end

  def vorgang=(value)
    @vorgang_id = value["id"]
  end

  def status
    case auftragStatus
      when "nicht_abgehakt"
        "UNCHECKED"
      when "abgehakt"
        "CHECKED"
      when "nicht_abarbeitbar"
        "NOT_CHECKABLE"
    end
  end

  def status=(value)
    @auftragStatus = case value
      when "UNCHECKED"
        "nicht_abgehakt"
      when "CHECKED"
        "abgehakt"
      when "NOT_CHECKABLE"
        "nicht_abarbeitbar"
      else
        value
    end
  end
end
