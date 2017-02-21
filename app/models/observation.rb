class Observation
  include ActiveModel::AttributeMethods
  include CitySDKSerialization

  attr_accessor :area_code, :geometry, :problems, :problem_service, :ideas, :idea_service

  self.serialization_attributes = [:id]

  def to_backend_params
    {
      stadtteilIds: area_code,
      oviWkt: geometry,
      probleme: problems,
      problemeKategorien: problem_service,
      ideen: ideas,
      ideenKategorien: idea_service
    }
  end 
end
