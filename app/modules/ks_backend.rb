module KSBackend
  require 'net/http'

  def self.requests(parameter = nil, response_class = RequestTimes)
    vorgaenge = self.get("vorgaenge", { just_times: true }.merge(parameter), RequestTimes)
    parameter[:just_count].blank? ? self.check_versions(vorgaenge, parameter) : vorgaenge
  end

  def self.request(id, parameter = {})
    self.check_versions self.get("vorgaenge", { id: id, just_times: true }.merge(parameter), RequestTimes), parameter
  end

  def self.create_request(parameter)
    self.post "vorgang", parameter, Request, true
  end

  def self.update_request(parameter)
    self.post "vorgangAktualisieren", parameter, Request, true
  end

  def self.services(parameter = nil)
    self.get "unterkategorien", parameter, Service
  end

  def self.service(id)
    self.post "kategorie", { 'id' => id }, ServiceDefinition, true
  end

  def self.comments(id)
    self.get "lobHinweiseKritik", { vorgang_id: id }, Comment
  end

  def self.create_comment(parameter)
    self.post "lobHinweiseKritik", parameter, Comment, true
  end

  def self.notes(id)
    self.get "kommentar", { vorgang_id: id }, Note
  end

  def self.create_note(parameter)
    self.post "kommentar", parameter, Note, true
  end

  def self.create_vote(parameter)
    self.post "unterstuetzer", parameter, Vote, true
  end

  def self.create_abuse(parameter)
    self.post "missbrauchsmeldung", parameter, Abuse, true
  end

  def self.create_photo(parameter)
    self.post "foto", parameter, Photo, true
  end

  def self.position_valid?(pos = {})
    return false if pos[:lat].blank? || pos[:long].blank?
    uri = URI("#{ KS_BACKEND_SERVICE_URL }position")
    uri.query = URI.encode_www_form(positionWGS84: "POINT (#{ pos[:lat] } #{ pos[:long] })")
    Net::HTTP.get_response(uri).is_a? Net::HTTPOK
  end

  def self.areas(parameter = nil)
    self.get 'grenzen', parameter, Area
  end

  def self.create_observation(parameter)
    self.post 'geoRss', parameter, Observation, true
  end

  private
  def self.get(be_method, parameter, response_class, only_one = false)
    uri = URI("#{ KS_BACKEND_SERVICE_URL }#{ be_method }")
    uri.query = URI.encode_www_form(parameter) unless parameter.blank?

    self.handle_response uri, Net::HTTP::Get.new(uri), response_class, only_one
  end

  def self.post(be_method, parameter, response_class, only_one = false)
    uri = URI("#{ KS_BACKEND_SERVICE_URL }#{ be_method }")

    req = Net::HTTP::Post.new(uri.path)
    req.set_form_data(parameter)

    self.handle_response uri, req, response_class, only_one
  end

  def self.handle_response(uri, req, response_class, only_one)
    begin
      req['Accept-Charset'] = 'UTF-8'
      response = Net::HTTP.start(uri.host, uri.port) do |http|
        http.request(req)
      end
    rescue Exception
      Rails.logger.error "Exception: #{ $!.inspect }, #{ $!.message }\n  " << $!.backtrace.join("\n  ")
      raise ErrorMessage.new(I18n.t("backend.unavailable"))
    end

    result = response.body.force_encoding('UTF-8')
    begin
      return response_class.new(JSON.parse(result)) if only_one
      JSON.parse(result).map do |elem|
        response_class.new(elem) if elem
      end
    rescue Exception
      Rails.logger.error "Exception: #{ $!.inspect }, #{ $!.message }\n  " << $!.backtrace.join("\n  ")
      raise ErrorMessage.new(result)
    end
  end

  def self.check_versions response_times, parameter = nil
    return_list = []
    reload_ids = []
    response_times.each do |rt|
      cached = Rails.cache.read(rt.id)
      if cached.blank? || rt.version > cached.version
        reload_ids << rt.id
      else
        return_list << cached
      end 
    end

    p = { ids: reload_ids }
    p[:authCode] = parameter[:authCode] unless parameter[:authCode].blank? if parameter
    self.get("vorgaenge", p, Request).each do |request|
      Rails.cache.write(request.id, request)
      return_list << request
    end unless reload_ids.blank?
    return_list
  end
end
