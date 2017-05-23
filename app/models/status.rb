class Status
  CITY_SDK = { 'PENDING' => 'gemeldet', 'RECEIVED' => 'offen', 'IN_PROCESS' => 'inBearbeitung',
               'PROCESSED' => 'geloest', 'REJECTED' => 'nichtLoesbar' }

  PERMISSABLE_CITY_SDK_KEYS = %w(IN_PROCESS PROCESSED REJECTED)

  OPEN311 = { 'open' => ['gemeldet', 'offen', 'inBearbeitung'],
              'closed' => ['geloest', 'nichtLoesbar'] }

  NON_PUBLIC = "intern"
  
  DELETED = "geloescht"

  def initialize(status)
    @city_sdk = CITY_SDK.detect { |_k, v| v == status }.first
    @open311 = OPEN311.detect { |_k, v| v.include?(status) }.first
    @backend = status
  end

  def self.open311_for_backend(open311_status)
    OPEN311.slice(*Array(open311_status).map(&:downcase)).values.flatten
  end

  def self.citysdk_for_backend(citysdk_status)
    CITY_SDK.slice(*Array(citysdk_status).map(&:upcase)).values.flatten
  end

  def self.valid_filter_values(values, target = :open311)
    values = values.split(/, ?/) if values.is_a?(String)
    (matches = case target
               when :open311
                 OPEN311.keys
               when :city_sdk
                 CITY_SDK.keys
               else
                 raise 'Unknown status target'
               end.map(&:upcase) & values.map(&:upcase)) && matches.size == values.size
  end

  def to_city_sdk
    @city_sdk
  end

  def to_open311
    @open311
  end

  def to_backend
    @backend
  end
end
