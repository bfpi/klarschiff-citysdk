class ErrorMessage < Exception
  include CitySDKSerialization

  attr_accessor :error

  self.serialization_attributes = [:error]

  def initialize(message)
    @error = message
  end
end