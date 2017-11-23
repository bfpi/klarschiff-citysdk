class Discovery
  include CitySDKSerialization

  attr_accessor :id, :name, :description, :parent

  self.serialization_attributes = [:changeset, :contact, :key_service]

  alias_attribute :service_code, :id
  alias_attribute :service_name, :name

  def changeset
    '2015-11-05 08:43'
  end

  def contact
    'Hanse- und Universitätsstadt Rostock, Kataster-, Vermessungs- und Liegenschaftsamt, Holbeinplatz 14, 18069 Rostock, Telefon: +49 381 381-6281, Telefax: +49 381 381-6902, E-Mail: klarschiff.hro@rostock.de'
  end

  def key_service
    'klarschiff.hro@rostock.de'
  end

  def endpoints
    [
        { specification: 'http://wiki.open311.org/GeoReport_v2', url: 'https://geo.sv.rostock.de/citysdk', changeset: changeset, type: 'production', formats: ['application/json', 'text/xml'] },
        { specification: 'http://wiki.open311.org/GeoReport_v2', url: 'https://support.klarschiff-hro.de/citysdk', changeset: changeset, type: 'test', formats: ['application/json', 'text/xml'] },
        { specification: 'http://wiki.open311.org/GeoReport_v2', url: 'https://demo.klarschiff-hro.de/citysdk', changeset: changeset, type: 'test', formats: ['application/json', 'text/xml'] }
    ]
  end

  private
  def serializable_methods(options)
    ret = []
    ret << :endpoints
    ret
  end
end
