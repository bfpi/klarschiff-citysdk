module Authorization

  @client = nil

  def self.check params

    case params['controller']
      when "requests/comments"
        self.checkActionPermission(params, "create_comment") if params['action'].eql? "create"

      when "requests/notes"
        self.checkActionPermission(params, "read_notes") if params['action'].eql? "index"
        self.checkActionPermission(params, "create_notes") if params['action'].eql? "create"

      when "requests"
        self.checkActionPermission(params, "create_request") if params['action'].eql? "create"
    end
  end

  def self.hasPermission? permission
    if @client.blank? || @client['permissions'].blank? || !@client['permissions'].include?(permission.to_s)
      return false
    end
    true
  end

  private
  def self.getClient params
    if params['api_key'].blank?
      raise "api_key missing"
    end

    key = params['api_key']
    if Clients[key].blank?
      raise "api_key invalid"
    end

    @client = Clients[key]
  end

  def self.checkActionPermission params, permission
    self.getClient params if @client.nil?
    raise "no_permision" unless self.hasPermission?(permission)
  end

end