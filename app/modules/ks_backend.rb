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

  def self.services(params = nil)
    self.get "unterkategorien", params, Service
  end

  def self.service(id)
    self.post "kategorie", { 'id' => id }, ServiceDefinition, true
  end

  def self.comments(id)
    self.get "lobHinweiseKritik", { vorgang_id: id }, Comment
  end

  def self.notes(id)
    self.get "kommentar", { vorgang_id: id }, Note
  end

  def self.create_vote(parameter)
    self.post "unterstuetzer", parameter, Vote, true
  end

  private
  def self.get(be_method, params, response_class, only_one = false)
    uri = URI("#{ KS_BACKEND_SERVICE_URL }#{ be_method }")
    uri.query = URI.encode_www_form(params) unless params.blank?

    begin
      res = Net::HTTP.get_response(uri)
    rescue Exception
      raise ErrorMessage.new("BE-Service currently unavailable")
    end
    self.handle_response res.body, response_class, only_one
  end

  def self.post(be_method, params, response_class, only_one = false)
    uri = URI("#{ KS_BACKEND_SERVICE_URL }#{ be_method }")

    begin
      res = Net::HTTP.post_form(uri, params)
    rescue Exception
      raise ErrorMessage.new("BE-Service currently unavailable")
    end
    p res.body
    self.handle_response res.body, response_class, only_one
  end

  def self.handle_response(response, response_class, only_one)
    begin
      return response_class.new(JSON.parse(response)) if only_one

      JSON.parse(response).map do |elem|
        response_class.new(elem) if elem
      end
    rescue Exception
      raise ErrorMessage.new(response)
    end
  end

end
