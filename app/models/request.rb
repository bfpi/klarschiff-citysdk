class Request
  include ActiveModel::AttributeMethods
  include DateFormatter
  include CitySDKSerialization

  validates :typ, presence: true
  validates :kategorie, presence: true
  validates :email, presence: true, length: { maximum: 300 }, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
  validates :title, presence: true, length: { maximum: 300 }
  validates :description, presence: true

  attr_accessor :id, :version, :datum, :typ, :betreff, :adresse, :statusKommentar, :kategorie, :details, :zustaendigkeit,
                :service_notice, :auftragDatum, :adress_id, :positionWGS84, :fotoGross, :fotoNormal, :fotoThumb,
                :zipcode, :lat, :long, :email, :trustLevel, :unterstuetzerCount, :fotowunsch

  self.serialization_attributes = [:service_request_id]

  IMAGE_SIZE_BIG = 'fotoGross'
  IMAGE_SIZE_NORMAL = 'fotoNormal'
  IMAGE_SIZE_THUMB = 'fotoThumb'

  alias_attribute :service_request_id, :id
  alias_attribute :status_notes, :statusKommentar
  alias_attribute :description, :details
  alias_attribute :title, :betreff
  alias_attribute :autorEmail, :email
  alias_attribute :photo_required, :fotowunsch
  alias_attribute :agency_responsible, :zustaendigkeit
  alias_attribute :address, :adresse
  alias_attribute :trust, :trustLevel
  alias_attribute :votes, :unterstuetzerCount

  def positionWGS84=(value)
    @lat, @long = value.gsub(/[A-Z()]*/, '').strip.split(" ")
  end

  def positionWGS84
    "POINT (#{ @lat } #{ @long })"
  end

  def status
    @status.to_open311
  end

  def status=(value)
    @status = Status.new(value)
  end

  def detailed_status
    @status.to_city_sdk
  end

  def service_code
    kategorie['id']
  end

  def service_name
    kategorie['name']
  end

  def requested_datetime
    format_date(datum)
  end

  def updated_datetime
    format_date(version)
  end

  def expected_datetime
    format_date(auftragDatum)
  end

  def media_url
    image(IMAGE_SIZE_BIG)
  end

  def title=(value)
    @betreff= value
  end

  def description=(value)
    @details= value
  end

  def attribute=(attributes)
    update_attributes(attributes)
  end

  def extended_attributes
    { service_object_type: nil, service_object_id: nil, detailed_status: detailed_status,
      media_urls: images, photo_required: photo_required, trust: trust, votes: votes }
  end

  def update_service(values)
    if values["service_code"] && values["service_code"].is_i?
      sc = KSBackend.service(values["service_code"].to_i)
      p sc
      @kategorie = sc.instance_values
      @typ = sc.parent['typ'] if sc.parent
    end
  end

  def to_backend_params
    {
      typ: typ,
      kategorie: service_code,
      positionWGS84: positionWGS84,
      autorEmail: email,
      betreff: betreff,
      details: details,
      #bild: nil, #media,
      resultObjectOnSubmit: true,
      photo_required: photo_required
    }
  end

  def errors_messages
    Exception.new(errors.messages.map { |k, v| "#{ k }: #{ v.join(', ') }" })
  end

  private
  def image(size)
    self.send(size).blank? ? nil : "#{ KS_IMAGES_URL }#{ self.send(size) }"
  end

  def images
    [
      image(IMAGE_SIZE_BIG),
      image(IMAGE_SIZE_NORMAL),
      image(IMAGE_SIZE_THUMB)
    ].compact
  end

  def serializable_methods(options)
    ret = []
    ret << :extended_attributes if options[:extensions]
    ret << [:status_notes, :status, :service_code, :service_name,
            :description, :title, :agency_responsible, :service_notice, :requested_datetime,
            :updated_datetime, :expected_datetime, :address, :adress_id, :lat, :long, :media_url,
            :zipcode] unless options[:show_only_id]
    ret.flatten
  end
end