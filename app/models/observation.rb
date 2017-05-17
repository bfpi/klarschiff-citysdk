class Observation
  include ActiveModel::AttributeMethods
  include CitySDKSerialization

  attr_accessor :area_code, :geometry, :problems, :problem_service, :problem_service_sub, :ideas, :idea_service, :idea_service_sub, :rss_id

  self.serialization_attributes = [:rss_id]

  def to_backend_params
    {
      stadtteilIds: area_code,
      oviWkt: geometry,
      probleme: problems,
      problemeHauptkategorien: problem_service,
      problemeUnterkategorien: problem_service_sub,
      ideen: ideas,
      ideenHauptkategorien: idea_service,
      ideenUnterkategorien: idea_service_sub
    }
  end 
end
