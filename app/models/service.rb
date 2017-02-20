class Service
  include CitySDKSerialization

  attr_accessor :id, :name, :description, :parent

  self.serialization_attributes = [:service_code, :service_name, :description, :metadata, :type, :keywords, :group]

  alias_attribute :service_name, :name

  def service_code
    id.to_s
  end

  def metadata
    false
  end

  def type
    'realtime'
  end

  def keywords
    parent['typ'] if parent
  end

  def group
    parent['name'] if parent
  end
end
