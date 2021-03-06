module CoreExtensions
  class ::String
    def to_boolean
      (v = YAML.load(self)) && (v.is_a?(TrueClass) || v.is_a?(FalseClass))
    end

    def is_i?
      /\A[-+]?\d+\z/ === self
    end
  end

  class ::Integer
    def is_i?
      true
    end
  end
end
