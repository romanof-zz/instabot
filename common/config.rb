#!/usr/bin/ruby
require "yaml"

def config
  @config = YAML.load_file("config.yml") if @config.nil?
  @config
end
