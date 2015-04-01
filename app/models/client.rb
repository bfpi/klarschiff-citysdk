class Client
  conf_file = Rails.root.join(*%w(config clients.yml))

  @@clients = File.open(conf_file) { |file| YAML::load file }

  def self.[](key)
    @@clients[key.to_s].try(:with_indifferent_access)
  end
end
