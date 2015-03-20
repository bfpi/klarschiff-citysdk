class ServicesController < ApplicationController

  def index
    @services = KSBackend.services
    respond_with @services, root: 'services', dasherize: false
  end

  def show
    @service = KSBackend.service(params[:service_id].to_i)
    respond_with @service, root: 'service_definition', element_name: 'service', dasherize: false
  end
end