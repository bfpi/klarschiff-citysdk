class ErrorMessage < Exception
  include CitySDKSerialization

  attr_accessor :code, :description, :http_code

  self.serialization_attributes = [:code, :description]

  def initialize(message)
    @code, internal, @description = message.split('#', 3) if message.include?("#")
    @description ||= internal || message
    pattern = Regexp.new(/\[http_code\:(\d*)\]/)
    @code = $1 if @code =~ pattern
    @http_code = $1 if message =~ pattern
  end

  def to_s
    @description
  end
end