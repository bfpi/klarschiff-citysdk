# Define constants with values configured in constants block of config/settings.yml
File.open(Rails.root.join('config', 'settings.yml')) { |file|
  YAML::load file }['constants'].each do |name, value|
    Kernel.const_set name.upcase, value
  end
