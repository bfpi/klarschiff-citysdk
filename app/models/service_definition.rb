class ServiceDefinition
  include CitySDKSerialization

  attr_accessor :id, :name, :parent

  self.serialization_attributes = [:service_code, :service_name, :keywords, :group]

  alias_attribute :service_code, :id
  alias_attribute :service_name, :name

  def keywords
    parent['typ'] if parent
  end

  def group
    parent['name'] if parent
  end
end
