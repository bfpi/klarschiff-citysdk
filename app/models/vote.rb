class Vote
  include ActiveModel::AttributeMethods
  include CitySDKSerialization
  include ValidationErrorFormatter

  attr_accessor :service_request_id, :author

  self.serialization_attributes = [:id]

  alias_attribute :id, :service_request_id

  def to_backend_params
    {
      vorgang: id,
      email: author,
      resultObjectOnSubmit: true
    }
  end

  def id=(value)
    @service_request_id = value
  end

end