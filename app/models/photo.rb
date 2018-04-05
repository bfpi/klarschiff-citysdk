class Photo
  include DateFormatter
  include CitySDKSerialization
  include SetMedia

  attr_accessor :id, :email

  self.serialization_attributes = [:id]

  alias_attribute :service_request_id, :id

  def datetime
    format_date(datum)
  end

  def to_backend_create_params
    {
        vorgang: id,
        email: email,
        bild: media,
        resultObjectOnSubmit: true
    }
  end

end
