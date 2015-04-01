class ApplicationController < ActionController::Base
  include Authorization
  include ParameterValidation
  respond_to :xml, :json

  before_filter do
    check_auth
  end

  rescue_from ErrorMessage do |ex|
    ex = ErrorMessage.new(ex.message) unless ex.class.to_s.eql?("ErrorMessage")
    respond_with(Array.wrap(ex), root: :error_messages, dasherize: false, location: discovery_url, status: ex.http_code || 422)
  end
end
