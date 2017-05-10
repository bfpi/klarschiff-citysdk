class RequestTimes
  #include ActiveModel::AttributeMethods
  #include DateFormatter
  include CitySDKSerialization
  #include ValidationErrorFormatter

  attr_accessor :id, :version, :count

  self.serialization_attributes = [:count]
end