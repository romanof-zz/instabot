#!/usr/bin/ruby
require_relative 'common/args'
require_relative 'scripts/likelatest'
require_relative 'scripts/getfollowers'
require_relative 'scripts/settypes'

case options[:operation].to_sym
when :likelatest
  likelatest options[:username]
when :getfollowers
  getfollowers options[:username], options[:source_account]
when :settypes
  set_follower_types
else
  puts 'unknown operation'
end
