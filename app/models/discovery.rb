class Discovery
  include CitySDKSerialization

  attr_accessor :id, :name, :description, :parent

  self.serialization_attributes = [:changeset, :contact, :key_service]

  alias_attribute :service_code, :id
  alias_attribute :service_name, :name

  def changeset
    '2015-08-14 12:33'
  end

  def contact
    'BFPI'
  end

  def key_service
    'Aktuell nicht verfügbar'
  end

  def endpoints
    { specification: 'http://wiki.open311.org/GeoReport_v2', endpoint: [
        { url: nil, changeset: changeset, type: 'production', formats: ['text/xml', 'application/json'] }
    ] }
  end

  private
  def serializable_methods(options)
    ret = []
    ret << :endpoints
    ret
  end
end
