class ApplicationController < ActionController::Base
  include Authorization
  include ParameterValidation
  respond_to :xml, :json

  before_filter do
    check_auth
  end

  rescue_from ErrorMessage do |ex|
    ex = ErrorMessage.new(ex.message) unless ex.is_a? ErrorMessage
    error = Array.wrap(ex)
    respond_with error, root: :error_messages, dasherize: false, location: discovery_url,
                 status: ex.http_code || 422, request.format.symbol.to_sym => error
  end
end
