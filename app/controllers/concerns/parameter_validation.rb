module ParameterValidation
  extend ActiveSupport::Concern

  included do
    private_instance_methods.select{ |m| m.to_s.start_with?("validate_") }.each do |method|
      before_action method
    end
  end

  private
  def validate_dates
    %w{ start_date end_date updated_after updated_before }.each do |date|
      unless params[date].blank?
        raise "date #{ date } invalid" if params[date].to_time.nil?
      end
    end
  end

  def validate_status
    unless params[:status].blank?
      raise "status invalid" unless Status.valid_filter_values(params[:status])
    end
  end

  def validate_detailed_status
    unless params[:detailed_status].blank?
      raise "status invalid" unless Status.valid_filter_values(params[:detailed_status], :city_sdk)
    end
  end

  def validate_service_request_id
    unless params[:service_request_id].blank?
      raise "service_request_id is not a number" unless params[:service_request_id].is_i?
    end
  end
end
