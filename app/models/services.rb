class Services

  def initialize(attributes)
    @attributes = attributes
  end

  def to_xml arghs
    xml = arghs[:builder]
    xml = Builder::XmlMarkup.new unless xml
    xml.service do
      xml.service_code @attributes['id']
      xml.service_name @attributes['name']
      xml.description
      xml.metadata false
      xml.type 'realtime'
      xml.keywords parent_value('typ')
      xml.group parent_value('name')
    end
    xml
  end

  def as_json arghs
    {
      service_code: @attributes['id'],
      service_name: @attributes['name'],
      description: nil,
      metadata: false,
      type: 'realtime',
      keywords: parent_value('typ'),
      group: parent_value('name')
    }
  end

  def parent_value val
    @attributes['parent'] ? @attributes['parent'][val] : nil
  end
end