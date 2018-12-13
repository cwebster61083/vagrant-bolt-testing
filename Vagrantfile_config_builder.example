vagrant_dir = File.dirname(__FILE__)
# The chdir ensures all relative paths expand consistently no matter where
# the vagrant command is run from.
Dir.chdir(vagrant_dir)

require 'vagrant-bolt'
require 'config_builder'

Vagrant.configure('2', &ConfigBuilder.load(
  :yaml_erb,
  :yamldir,
  File.expand_path('../config', __FILE__)
))
