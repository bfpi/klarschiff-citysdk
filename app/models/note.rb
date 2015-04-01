class Note
  include DateFormatter
  include CitySDKSerialization
  include ValidationErrorFormatter

  attr_accessor :id, :text, :datum, :vorgang, :nutzer

  self.serialization_attributes = [:jurisdiction_id, :comment, :datetime, :service_request_id, :author]

  alias_attribute :service_request_id, :id
  alias_attribute :comment, :text
  alias_attribute :author, :nutzer

  def datetime
    format_date(datum)
  end

  def service_request_id
    vorgang['id']
  end

  def to_backend_create_params
    {
        vorgang_id: id,
        autorEmail: author,
        text: text,
    }
  end
end