class Discovery
  include CitySDKSerialization

  attr_accessor :id, :name, :description, :parent

  self.serialization_attributes = [:changeset, :contact, :key_service]

  alias_attribute :service_code, :id
  alias_attribute :service_name, :name

  def changeset
    DISCOVERY_CHANGESET
  end

  def contact
    DISCOVERY_CONTACT
  end

  def key_service
    DISCOVERY_KEY_SERVICE
  end

  def endpoints
    DISCOVERY_ENDPOINTS
  end

  private
  def serializable_methods(options)
    ret = []
    ret << :endpoints
    ret
  end
end
