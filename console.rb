#!/usr/bin/ruby
require_relative 'common/args'
require_relative 'scripts/likelatest'
require_relative 'scripts/getfollowers'

case options[:operation].to_sym
when :likelatest
  likelatest options[:username]
when :getfollowers
  getfollowers options[:username], options[:source_account]
else
  puts 'unknown operation'
end
