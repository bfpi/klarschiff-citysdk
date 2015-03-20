class Service
  include CitySDKSerialization

  attr_accessor :id, :name, :description, :parent

  self.serialization_attributes = [:service_code, :service_name, :description, :metadata, :type, :keywords, :group]

  alias_attribute :service_code, :id
  alias_attribute :service_name, :name

  def metadata
    false
  end

  def type
    'realtime'
  end

  def keywords
    parent['typ']
  end

  def group
    parent['name']
  end
end