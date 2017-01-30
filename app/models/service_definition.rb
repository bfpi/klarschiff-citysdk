class ServiceDefinition
  include CitySDKSerialization

  attr_accessor :id, :name, :parent, :typ, :nameEscapeHtml

  self.serialization_attributes = [:service_code, :service_name, :keywords, :group]

  alias_attribute :service_code, :id
  alias_attribute :service_name, :name

  def keywords
    parent['typ']
  end

  def group
    parent['name']
  end
end
