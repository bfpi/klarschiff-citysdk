class ServicesController < ApplicationController

  def index
    options = {}
    options.update(extensions: params[:extended]&.to_boolean) if params[:extended].present?
    @services = KSBackend.services(params[:api_key] ? backend_params(options) : options)
    respond_with(@services, root: :services, dasherize: false)
  end

  def show
    @service = KSBackend.service(params[:service_id].to_i)
    respond_with(Array.wrap(@service), root: :service_definition, element_name: :service, dasherize: false,
                 location: services_url)
  end
end
