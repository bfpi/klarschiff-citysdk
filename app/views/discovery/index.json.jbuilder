json.discovery do
  json.changeset        "2015-02-27 14:20"
  json.contact          "BFPI"
  json.key_service      "Aktuell nicht verfügbar"
  json.endpoints do
    json.specification  "http://wiki.open311.org/GeoReport_v2"
    json.endpoint do
      json.url          ""
      json.changeset    "2015-02-27 14:20"
      json.type         "production"
      json.formats do
        json.array! [
          "text/json",
          "application/json"
        ]
      end
    end
  end
end