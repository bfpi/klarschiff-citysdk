module SetMedia
  extend ActiveSupport::Concern

  included do
    attr_accessor :media

    def media=(value)
      return if value.blank?
      img = if value.respond_to? :path
        Magick::Image::read(value.path)
      else
        Magick::Image::read_inline(value)
      end.first
      img.format = "JPEG" unless img.format == "JPEG"
      if img.columns > IMAGE_MAX_WIDTH || img.rows > IMAGE_MAX_HEIGHT
        img.change_geometry!("#{ IMAGE_MAX_WIDTH }x#{ IMAGE_MAX_HEIGHT }") { |cols, rows, image| image.resize!(cols, rows) }
      end
      @media = Base64.encode64(img.to_blob)
    end
  end
end