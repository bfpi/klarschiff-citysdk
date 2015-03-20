module DateFormatter
  extend ActiveSupport::Concern

  included do
    private
    def format_date(date)
      return nil if date.blank?
      Time.at(date / 1000)
    end
  end

end