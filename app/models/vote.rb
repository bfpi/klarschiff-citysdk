class Vote
  include ActiveModel::AttributeMethods
  include CitySDKSerialization
  include ValidationErrorFormatter

  attr_accessor :service_request_id, :author, :privacy_policy_accepted, :status_updates_for_supporter

  self.serialization_attributes = [:id]

  alias_attribute :id, :service_request_id

  def to_backend_params
    {
      vorgang: id,
      email: author,
      resultObjectOnSubmit: true,
      datenschutz: privacy_policy_accepted,
      statusaenderung_an_unterstuetzer: status_updates_for_supporter
    }
  end

  def id=(value)
    @service_request_id = value
  end
end
