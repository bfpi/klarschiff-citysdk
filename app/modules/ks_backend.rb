module KSBackend
  require 'net/http'

  def self.requests(params = nil)
    self.get "vorgaenge", params, Request
  end

  def self.request(id)
    self.get "vorgaenge", { id: id }, Request
  end

  def self.create_request(parameter)
    self.post "vorgang", parameter, Request, true
  end

  def self.update_request(parameter)
    self.post "vorgangAktualisieren", parameter, Request, true
  end

  def self.services(params = nil)
    self.get "unterkategorien", params, Service
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

  def self.position_valid?(pos = {})
    return false if pos[:lat].blank? || pos[:long].blank?
    uri = URI("#{ KS_BACKEND_SERVICE_URL }position")
    uri.query = URI.encode_www_form(positionWGS84: "POINT (#{ pos[:lat] } #{ pos[:long] })")
    Net::HTTP.get_response(uri).is_a? Net::HTTPOK
  end

  private
  def self.get(be_method, params, response_class, only_one = false)
    uri = URI("#{ KS_BACKEND_SERVICE_URL }#{ be_method }")
    uri.query = URI.encode_www_form(params) unless params.blank?

    self.handle_response uri, Net::HTTP::Get.new(uri), response_class, only_one
  end

  def self.post(be_method, params, response_class, only_one = false)
    uri = URI("#{ KS_BACKEND_SERVICE_URL }#{ be_method }")

    req = Net::HTTP::Post.new(uri.path)
    req.set_form_data(params)

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
end
