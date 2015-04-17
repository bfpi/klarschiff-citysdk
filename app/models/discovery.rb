class Discovery
  include CitySDKSerialization

  attr_accessor :id, :name, :description, :parent

  self.serialization_attributes = [:changeset, :contact, :key_service]

  alias_attribute :service_code, :id
  alias_attribute :service_name, :name

  def changeset
    '2015-02-27 14:20'
  end

  def contact
    'BFPI'
  end

  def key_service
    'Aktuell nicht verfügbar'
  end

  def endpoints
    { specification: 'http://wiki.open311.org/GeoReport_v2', endpoint: [
        { url: nil, changeset: '2015-02-27 14:20', type: 'production', formats: ['text/json', 'application/json'] }
    ] }
  end

  private
  def serializable_methods(options)
    ret = []
    ret << :endpoints
    ret
  end
end