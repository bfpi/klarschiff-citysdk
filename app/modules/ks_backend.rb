module KSBackend
  require 'net/http'

  def self.requests params = {}
    uri = URI("#{ KS_BACKEND_SERVICE_URL }vorgaenge")
    uri.query = URI.encode_www_form(params)

    res = Net::HTTP.get_response(uri)
    requests = []
    JSON.parse(res.body).each do |request|
      requests << Request.new(request)
    end
    requests
  end

  def self.request id
    self.requests({ id: id })
  end

  def self.services params = {}
    uri = URI("#{ KS_BACKEND_SERVICE_URL }unterkategorien")
    res = Net::HTTP.get_response(uri)
    services = []
    JSON.parse(res.body).each do |service|
      services << Services.new(service)
    end
    services
  end

  def self.service id
    uri = URI("#{ KS_BACKEND_SERVICE_URL }kategorie")
    res = Net::HTTP.post_form(uri, 'id' => id)
    [ServiceDefinition.new(JSON.parse(res.body))]
  end

end
