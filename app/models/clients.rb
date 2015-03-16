class Clients
  file = Rails.root.join(*%w(config clients.yml))

  @@clients = File.open(file) { |f| YAML::load f }.tap do |s|
    s.each do |key, value|
      value.dup.each do |k, v|
        if v.is_a?(Array)
          v.each_with_index { |val, idx| value["#{ k }_#{ idx }"] = val }
        end
      end if value.is_a?(Hash)
    end
  end

  def self.[](key)
    @@clients[key.to_s]
  end
end
