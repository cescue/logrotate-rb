require 'fileutils'
require 'zip'
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

FileToRotate = Struct.new(:name, :index)
files_to_rotate = []

config['directories'].each do |directory|
  Dir["#{directory}/*"].each do |entry|
    next unless entry =~ pattern_to_rotate

    index = $1&.to_i || 0

    # Removing index extension will make it simpler to increment later on.
    filename = entry.reverse
                    .sub("#{index}.", '')
                    .reverse

    files_to_rotate << FileToRotate.new(filename, index)
  end
end

files_to_rotate.sort_by! { |file| file.index }

files_to_rotate.each do |file|
  if file.index == config['max_historic_files_per_log']&.to_i
    FileUtils.rm(file.name)
    next
  end

  write_from = file.index.zero? ? file.name : "#{file.name}.#{file.index}"

  if config['compress']
    write_to = "#{file.name}.zip.#{file.index + 1}"
  else
    write_to = "#{file.name}.#{file.index + 1}"

    FileUtils.mv(write_to, write_from)
  end
end
