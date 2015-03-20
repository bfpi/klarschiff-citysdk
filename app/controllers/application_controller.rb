class ApplicationController < ActionController::Base
  include Authorization
  include ParameterValidation
  respond_to :xml, :json

  before_filter do
    check_auth
  end

  rescue_from Exception do |ex|
    ErrorMessage.new(ex.message) unless ex.class.to_s.eql?("ErrorMessage")
    respond_with ex, dasherize: false, :location => discovery_url
  end
end
