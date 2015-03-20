class DiscoveryController < ApplicationController

  def index
    respond_with Discovery.new, dasherize: false
  end
end