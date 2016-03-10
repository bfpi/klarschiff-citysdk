class RequestTimes
  #include ActiveModel::AttributeMethods
  #include DateFormatter
  include CitySDKSerialization
  #include ValidationErrorFormatter
  
    attr_accessor :id, :version
end