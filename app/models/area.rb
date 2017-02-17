class Area
  include CitySDKSerialization 
  
  attr_accessor :id, :name, :grenze

  self.serialization_attributes = [:id, :name, :grenze]
end
