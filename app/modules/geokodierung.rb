module Geokodierung

  def self.find(adresse)
    uri = URI("#{ GEOKODIERUNG_URL }")
    pattern = Regexp.new(/(\d{5})*(?:\.? |\.|,)*([a-zA-Z \.]*)\s(\d*)([a-zA-Z]*)(?:\.? |\.|,)*(\d{5})*/)

    pattern.match(adresse)

    str = $2
    hnr = $3
    hnr_z = $4
    plz = $1 || $5

    uri.query = URI.encode_www_form({
                                      hausnummer: hnr,
                                      hausnummer_zusatz: hnr_z,
                                      strasse_name: str.gsub("trasse", "tr.").gsub("traße", "tr."),
                                      postleitzahl: plz,
                                      srid: 4326
                                    })

    begin
      res = Net::HTTP.get_response(uri)
      raise(ErrorMessage, I18n.t("geocoding.blank_response", { adresse: adresse})) if res.body.blank?
      JSON.parse(res.body)
    rescue Errno::ECONNREFUSED => e
      raise ErrorMessage, I18n.t("geocoding.unavailable")
    end
  end
end