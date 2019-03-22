module SetMedia
  extend ActiveSupport::Concern

  included do
    attr_accessor :media

    def media=(value)
      return if value.blank?
      img = if value.respond_to? :path
        MiniMagick::Image.open(value.path)
      else
        MiniMagick::Image.read(Base64.decode64(value))
      end
      img.format('JPEG') unless img.type == 'JPEG'
      if img.width > IMAGE_MAX_WIDTH || img.height > IMAGE_MAX_HEIGHT
        img.resize "#{ IMAGE_MAX_WIDTH }x#{ IMAGE_MAX_HEIGHT }"
      end
      @media = Base64.encode64(img.to_blob)
    end
  end
end
