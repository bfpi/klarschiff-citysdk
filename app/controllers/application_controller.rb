class ApplicationController < ActionController::Base
  respond_to :xml, :json

  before_filter do
    Authorization.check params
  end
  before_filter :validate_params

  rescue_from Exception do |ex|
    render text: ex.message
  end

  private
  def validate_params
    unless params[:status].blank?
      raise "status invalid" unless Status.const_defined?(params[:status].upcase)
    end

    %w{ start_date end_date updated_after updated_before }.each do |date|
      unless params[date].blank?
        raise "date #{ date } invalid" if params[date].to_time.nil?
      end
    end
  end
end
