# Logrotate

A portable (and _very_ limited) ruby implementation of logrotate.

## Configuration

Files to rotate are specified in a YAML configuration file, which is provided
as a command line argument. Here is an example:

```yaml
# Only files in these directories will be rotated
directories:
  - /path/to/my/log
  - /path/to/my/other_log

# Only files with the following extensions will be rotated
extensions:
  - log

# Files will be rotated this many times until they are deleted
max_historic_files_per_log: 5

# Once rotated, files will be saved to a zip archive
compress: true
```

## Usage

```
  ruby logrotate.rb [config file]
```
