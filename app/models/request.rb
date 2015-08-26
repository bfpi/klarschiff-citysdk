class Request
  include ActiveModel::AttributeMethods
  include DateFormatter
  include CitySDKSerialization
  include ValidationErrorFormatter

  validates :service_code, presence: true
  validates :description, presence: true
  validate do
    errors.add(:position, I18n.t("activemodel.errors.models.request.attributes.position.invalid")) if lat.blank? && long.blank?
  end

  attr_accessor :id, :version, :datum, :typ, :adresse, :statusKommentar, :kategorie, :beschreibung, :zustaendigkeitFrontend,
                :service_notice, :auftragDatum, :adress_id, :positionWGS84, :fotoGross, :fotoNormal, :fotoThumb,
                :zipcode, :lat, :long, :email, :trustLevel, :unterstuetzerCount, :fotowunsch, :media,
                :job_status, :job_detail_attributes, :priority, :statusDatum, :auftragStatus, :auftragPrioritaet, :delegiertAn,
                :beschreibungFreigabeStatus, :fotoFreigabeStatus

  self.serialization_attributes = [:service_request_id]

  IMAGE_SIZE_BIG = 'fotoGross'
  IMAGE_SIZE_NORMAL = 'fotoNormal'
  IMAGE_SIZE_THUMB = 'fotoThumb'

  alias_attribute :service_request_id, :id
  alias_attribute :status_notes, :statusKommentar
  alias_attribute :description, :beschreibung
  alias_attribute :autorEmail, :email
  alias_attribute :photo_required, :fotowunsch
  alias_attribute :agency_responsible, :zustaendigkeitFrontend
  alias_attribute :address, :adresse
  alias_attribute :trust, :trustLevel
  alias_attribute :votes, :unterstuetzerCount
  alias_attribute :detailed_status_datetime, :statusDatum
  alias_attribute :job_priority, :auftragPrioritaet
  alias_attribute :delegation, :delegiertAn

  def positionWGS84=(value)
    @lat, @long = value.gsub(/[A-Z()]*/, '').strip.split(" ")
  end

  def address_string=(value)
    return if value.blank? || (lat.present? && long.present?)
    if Geocoder.valid?(value)
      @long, @lat = Geocoder.find(value)['features'].first['geometry']['coordinates']
    end
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

  def detailed_status=(value)
    @status = Status.new(Status::CITY_SDK.detect { |k, _v| k == value }.last)
  end

  def service_code
    kategorie ? kategorie['id'].to_s : nil
  end

  def service_name
    kategorie ? kategorie['name'] : nil
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
    image(IMAGE_SIZE_NORMAL)
  end

  def description
    approval_status(beschreibungFreigabeStatus, @beschreibung)
  end

  def description=(value)
    return if beschreibungFreigabeStatus == "intern"
    @beschreibung = value
  end

  def status_notes=(value)
    @statusKommentar = value
  end

  def photo_required=(value)
    @fotowunsch = value
  end

  def job_priority=(value)
    @auftragPrioritaet = value
  end

  def job_status
    case auftragStatus
      when "nicht_abgehakt"
        "UNCHECKED"
      when "abgehakt"
        "CHECKED"
      when "nicht_abarbeitbar"
        "NOT_CHECKABLE"
    end
  end

  def job_status=(value)
    @auftragStatus = case value
      when "UNCHECKED"
        "nicht_abgehakt"
      when "CHECKED"
        "abgehakt"
      when "NOT_CHECKABLE"
        "nicht_abarbeitbar"
    end
  end

  def media=(value)
    img = Magick::Image::read_inline(value).first
    img.format = "JPEG" unless img.format == "JPEG"
    if img.columns > IMAGE_MAX_WIDTH || img.rows > IMAGE_MAX_HEIGHT
      img.change_geometry!("#{ IMAGE_MAX_WIDTH }x#{ IMAGE_MAX_HEIGHT }") { |cols, rows, image| image.resize!(cols, rows) }
    end
    @media = Base64.encode64(img.to_blob)
  end

  def attribute=(attributes)
    update_attributes(attributes)
  end

  def extended_attributes
    ea = { detailed_status: detailed_status, detailed_status_datetime: format_date(detailed_status_datetime),
           media_urls: images, photo_required: photo_required, trust: trust, votes: votes }
    ea.merge!({ delegation: delegation, job_status: job_status, job_priority: job_priority }) if @job_detail_attributes
    ea
  end

  def service_code=(value)
    if value.is_i?
      sc = KSBackend.service(value.to_i)
      @kategorie = sc.instance_values
      @typ = sc.parent['typ'] if sc.parent
    end
  end

  def to_backend_create_params
    {
      typ: typ,
      kategorie: service_code,
      positionWGS84: positionWGS84,
      autorEmail: email,
      beschreibung: beschreibung,
      bild: media,
      resultObjectOnSubmit: true,
      fotowunsch: photo_required
    }
  end

  def to_backend_update_params
    to_backend_create_params.merge(
      id: id,
      status: @status.to_backend,
      statusKommentar: statusKommentar,
      prioritaet: priority,
      delegiertAn: delegation,
      auftragStatus: auftragStatus,
      auftragPrioritaet: job_priority
    ).delete_if { |_, value| value.nil? }
  end

  private
  def image(size)
    return nil if self.send(size).blank?

    if fotoFreigabeStatus.eql?("intern")
      "#{ $request.protocol }#{ $request.host_with_port }#{
      ActionController::Base.new.view_context.asset_url("#{ size }.jpg") }"
    else
      "#{ KS_IMAGES_URL }#{ self.send(size) }"
    end
  end

  def images
    [
      image(IMAGE_SIZE_BIG),
      image(IMAGE_SIZE_NORMAL),
      image(IMAGE_SIZE_THUMB)
    ].compact
  end

  def serializable_methods(options)
    @job_detail_attributes = options[:job_details]

    ret = []
    ret << :extended_attributes if options[:extensions]
    ret |= [:status_notes, :status, :service_code, :service_name,
            :description, :agency_responsible, :service_notice, :requested_datetime,
            :updated_datetime, :expected_datetime, :address, :adress_id, :lat, :long, :media_url,
            :zipcode] unless options[:show_only_id]
    ret
  end

  def approval_status(approval_status, return_text)
    approval_status.eql?("intern") ? "redaktionelle Prüfung ausstehend" : return_text
  end
end
