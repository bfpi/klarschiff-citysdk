module CitySDKSerialization
  extend ActiveSupport::Concern

  included do
    include ActiveModel::Model
    include ActiveModel::Serialization
    cattr_accessor :serialization_attributes

    def jurisdiction_id
      JURISDICTION_ID
    end

    def assign_attributes(values)
      values.each do |k, v|
        send("#{ k }=", v)
      end
    end

    def attributes
      hsh = {}
      self.class.serialization_attributes.each do |attr|
        hsh[attr] = nil
      end
      hsh
    end

    def to_xml(options)
      serializable_hash(serialization_options(options)).to_xml options.merge(root: (options[:element_name] || self.class.name.underscore))
    end

    def as_json(options)
      serializable_hash(serialization_options(options))
    end

    def method_missing(method, *arguments, &block)
      if method.to_s =~ /.*=$/
        Rails.logger.info "Method #{ method } not found." unless Rails.env.production?
      else
        super
      end
    end

    private
    def serialization_options(options)
      {}.tap do |hsh|
        hsh[:methods] = serializable_methods(options) if respond_to? :serializable_methods, true
      end
    end
  end
end
