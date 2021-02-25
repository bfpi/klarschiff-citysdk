class Comment
  include DateFormatter
  include CitySDKSerialization

  attr_accessor :id, :freitext, :datum, :vorgang, :autorEmail, :empfaengerEmail, :privacy_policy_accepted

  self.serialization_attributes = [:id, :jurisdiction_id, :comment, :datetime, :service_request_id, :author]

  alias_attribute :service_request_id, :id
  alias_attribute :comment, :freitext
  alias_attribute :author, :autorEmail

  def datetime
    format_date(datum)
  end

  def service_request_id
    vorgang['id']
  end

  def to_backend_create_params
    {
        vorgang: id,
        email: author,
        freitext: freitext,
        datenschutz: privacy_policy_accepted
    }
  end
end
