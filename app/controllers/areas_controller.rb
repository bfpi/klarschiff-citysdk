class AreasController < ApplicationController
  #Liste von Gebietsgrenzen
  #params:
  # api_key         optional - API-Key
  # area_code       optional - IDs der selektierten Stadtteile
  # with_districts  optional - Response mit allen verfügbaren Stadtteilgrenzen
  def index
    filter = {}
    filter[:ids] = params[:area_code] unless params[:area_code].blank?
    filter[:with_districts] = params[:with_districts] unless params[:with_districts].blank?
    respond_with(KSBackend.areas(filter).each { |ar| ar.grenze = eval(ar.grenze || '') }, root: :areas, dasherize: false)
  end
end
