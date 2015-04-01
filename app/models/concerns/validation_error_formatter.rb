module ValidationErrorFormatter
  extend ActiveSupport::Concern

  included do
    def errors_messages
      ErrorMessage.new("##{ errors.messages.map { |_k, v| "#{ v.join(', ') }" }.join(', ') }")
    end
  end

end