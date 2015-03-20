class Note
  include DateFormatter
  include CitySDKSerialization
  attr_accessor :id, :text, :datum, :vorgang, :nutzer

  self.serialization_attributes = [:id, :jurisdiction_id, :comment, :datetime, :service_request_id, :author]

  alias_attribute :comment, :text
  alias_attribute :author, :nutzer

  def datetime
    format_date(datum)
  end

  def service_request_id
    vorgang['id']
  end
end