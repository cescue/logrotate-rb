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

pattern_to_rotate = %r{
  ^
  .+                                           # filename
  \.(?:#{config['extensions'].join('|')})      # original file extension, eg .log
  #{'(?:.zip)?' if config['compress'] == true} # .zip extention if applicable
  (?:\.(\d+))?                                 # index after extension, eg .1
  $
}x

config['directories'].each do |directory|
  Dir["#{directory}/*"].each do |entry|
    next unless entry =~ pattern_to_rotate

  end
end
