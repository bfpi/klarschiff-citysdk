class ServiceDefinition
  include CitySDKSerialization

  attr_accessor :id, :name, :parent, :d3

  self.serialization_attributes = [:service_code, :service_name, :keywords, :group]

  alias_attribute :service_code, :id
  alias_attribute :service_name, :name

  def keywords
    parent['typ'] if parent
  end

  def group
    parent['name'] if parent
  end

  def document_url
    d3 ? d3['url'] : ""
  end

  def serializable_methods(options)
    ret = []
    ret |= [:document_url] if options[:document_url]
    ret
  end
end
