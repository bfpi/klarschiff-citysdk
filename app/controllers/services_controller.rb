class ServicesController < ApplicationController

  def index
    @services = KSBackend.services
    respond_with @services, root: 'services'
  end

  def show
    @service = KSBackend.service(params[:service_id].to_i)
    respond_with @service, root: 'service_definition', dasherize: false
  end
end