module Authorization
  extend ActiveSupport::Concern

  included do
    def has_permission?(permission)
      (client = current_client(true)) && client['permissions'].try(:include?, permission)
    end

    private
    def check_auth
      case controller_path
        when "requests/comments"
          check_action_permission(:create_comments) if action_name == "create"

        when "requests/notes"
          check_action_permission(:read_notes) if action_name == "index"
          check_action_permission(:create_notes) if action_name == "create"

        when "requests"
          check_action_permission(:create_request) if action_name == "create"
          check_action_permission(:update_request) if action_name == "update"
      end
    end
  end

  private
  def current_client(skip_raise = false)
    if params['api_key'].blank?
      raise ErrorMessage, "[http_code:400]##{ t("api_key.missing") }" unless skip_raise
      return
    end

    key = params['api_key']
    if Client[key].blank?
      raise ErrorMessage, "[http_code:401]##{ t("api_key.invalid") }" unless skip_raise
      return
    end

    Client[key]
  end

  def check_action_permission(permission)
    current_client if @client.nil?
    raise ErrorMessage, "[http_code:403]##{ t("api_key.no_permision") }" unless has_permission?(permission)
  end

end
