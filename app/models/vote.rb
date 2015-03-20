class Vote
  include ActiveModel::AttributeMethods
  include CitySDKSerialization

  validates :email, presence: true, length: { maximum: 300 }, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }

  attr_accessor :service_request_id, :email

  self.serialization_attributes = [:id]

  alias_attribute :id, :service_request_id

  def to_backend_params
    {
      vorgang: id,
      email: email,
      resultObjectOnSubmit: true
    }
  end

  def id=(value)
    @service_request_id = value
  end

end