class Abuse
  include DateFormatter
  include CitySDKSerialization

  attr_accessor :id, :text, :autorEmail

  self.serialization_attributes = [:id]

  alias_attribute :service_request_id, :id
  alias_attribute :comment, :text
  alias_attribute :author, :autorEmail

  def datetime
    format_date(datum)
  end

  def to_backend_create_params
    {
        vorgang: id,
        email: author,
        text: text,
        resultObjectOnSubmit: true
    }
  end

end