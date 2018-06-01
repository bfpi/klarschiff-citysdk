class Service
  include CitySDKSerialization

  attr_accessor :id, :name, :description, :parent, :typ, :d3

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
    typ || parent['typ']
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
