class Comment
  include DateFormatter
  include CitySDKSerialization
  attr_accessor :id, :freitext, :datum, :vorgang, :autorEmail, :empfaengerEmail

  self.serialization_attributes = [:id, :jurisdiction_id, :comment, :datetime, :service_request_id]

  alias_attribute :comment, :freitext
  alias_attribute :author, :autorEmail

  def datetime
    format_date(datum)
  end

  def service_request_id
    vorgang['id']
  end

  private
  def serializable_methods(options)
    ret = []
    ret << :author if options[:author]
    ret
  end
end