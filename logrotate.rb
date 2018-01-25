require 'fileutils'
require 'yaml'

DEFAULT_CONFIGURATION = {
  'max_historic_files_per_log' => 10,
  'compress' => true,
  'extensions' => ['log']
}

config = YAML.load_file('logrotaterb.yaml')

config.merge!(DEFAULT_CONFIGURATION)

abort('No directories specified. Nothing to do.') unless config['directories']

config['directories'].each do |directory|
  Dir["#{directory}/*"].each do |entry|
    next unless entry =~ /^.*\.(#{config['extensions'].join('|')})(?:\.\d+)?$/

  end
end
