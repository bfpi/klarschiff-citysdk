module Geocoder
  def self.find(address)
    uri = URI(GEOCODER_URL)

    unless match = valid?(address)
      raise ErrorMessage, I18n.t("geocoding.invalid_address", { address: address })
    end

    uri.query = URI.encode_www_form({
      hausnummer: match[:no],
      hausnummer_zusatz: match[:no_addition],
      strasse_name: match[:street].gsub("trasse", "tr.").gsub("traße", "tr."),
      postleitzahl: match[:zip],
      srid: 4326
    })

    begin
      res = Net::HTTP.get_response(uri)
      raise ErrorMessage, I18n.t("geocoding.blank_response", { address: address }) if res.body.blank?
      JSON.parse res.body
    rescue Errno::ECONNREFUSED
      raise ErrorMessage, I18n.t("geocoding.unavailable")
    end
  end

  def self.valid?(address)
    return unless address =~ /(\d{5})/
    attr = { zip: $1 }
    address.delete! $1, ','
    return unless address =~ /([a-zA-Zß \.]*)\s(\d*)([a-zA-Z ]*)/
    attr.merge street: $1, no: $2, no_addition: $3
  end
end
