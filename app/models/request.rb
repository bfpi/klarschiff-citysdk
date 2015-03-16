class Request

  IMAGE_SIZE_BIG = 'fotoGross'
  IMAGE_SIZE_NORMAL = 'fotoNormal'
  IMAGE_SIZE_THUMB = 'fotoThumb'

  def initialize(attributes)
    @attributes = attributes
  end

  def to_xml arghs

    Rails.logger.info @attributes.inspect

    xml = arghs[:builder]
    xml = Builder::XmlMarkup.new unless xml
    xml.request do
      xml.service_request_id @attributes['id']
      xml.status_notes @attributes['statusKommentar']
      xml.status Status.open_or_closed(@attributes['status'])
      xml.service_code @attributes['kategorie']['id']
      xml.service_name @attributes['kategorie']['name']
      xml.description @attributes['details']
      xml.title @attributes['betreff']
      xml.agency_responsible @attributes['zustaendigkeit']
      xml.service_notice nil
      xml.requested_datetime formatDate(@attributes['datum'])
      xml.updated_datetime formatDate(@attributes['version'])
      xml.expected_datetime formatDate(@attributes['auftragDatum'])
      xml.address @attributes['adresse']
      xml.adress_id nil
      xml.lat position[0]
      xml.long position[1]
      xml.media_url image(IMAGE_SIZE_BIG)
      xml.zipcode nil
      xml.extended_attributes do
        xml.service_object_type nil
        xml.service_object_id nil
        xml.detailed_status Status.constant_from_value(@attributes['status'])
        xml.media_urls do |mu|
          images.each do |img|
            xml.media_url img
          end
        end
        xml.trust nil # Ticket 325
        xml.votes nil # Ticket 330
      end if arghs[:extensions] && arghs[:extensions].eql?("true")
    end
    xml
  end

  def as_json arghs
    ret = {
      service_request_id: @attributes['id'],
      status_notes: @attributes['statusKommentar'],
      status: Status.open_or_closed(@attributes['status']),
      service_code: @attributes['kategorie']['id'],
      service_name: @attributes['kategorie']['name'],
      description: @attributes['details'],
      title: @attributes['betreff'],
      agency_responsible: @attributes['zustaendigkeit'],
      service_notice: nil,
      requested_datetime: formatDate(@attributes['datum']),
      updated_datetime: formatDate(@attributes['version']),
      expected_datetime: formatDate(@attributes['auftragDatum']),
      address: @attributes['adresse'],
      adress_id: nil,
      lat: position[0],
      long: position[1],
      media_url: image(IMAGE_SIZE_BIG),
      zipcode: nil
    }
    if arghs[:extensions] && arghs[:extensions].eql?("true")
      ret['extended_attributes'] = {
        service_object_type: nil,
        service_object_id: nil,
        detailed_status: Status.constant_from_value(@attributes['status']),
        media_urls: images || nil,
        trust: nil, # Ticket 325
        votes: nil # Ticket 330
      }
    end
    ret
  end

  private
  def formatDate date
    return nil if date.blank?
    Time.at(date / 1000)
  end

  def position
    @attributes['positionWGS84'].gsub(/[A-Z()]*/, '').strip.split(" ")
  end

  def image size
    @attributes[size].blank? ? nil : "#{ KS_IMAGES_URL }#{ @attributes[size] }"
  end

  def images
    [
      image(IMAGE_SIZE_BIG),
      image(IMAGE_SIZE_NORMAL),
      image(IMAGE_SIZE_THUMB)
    ].compact
  end
end