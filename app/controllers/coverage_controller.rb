class CoverageController < ApplicationController
  def valid
    respond_with({ result: KSBackend.position_valid?(params.permit(:lat, :long)) })
  end
end
