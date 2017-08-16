#!/usr/bin/ruby
require_relative 'common/args'
require_relative 'scripts/getfollowers'
require_relative 'scripts/settypes'
require_relative 'scripts/likelatest'
require_relative 'scripts/unfollow'
require_relative 'scripts/publicengage'

case options[:operation].to_sym
when :likelatest
  likelatest options[:username]
when :getfollowers
  getfollowers options[:username], options[:source_account]
when :settypes
  set_follower_types
when :unfollow
  unfollow options[:username]
when :publicengage
  publicengage options[:username], options[:lang]
else
  puts 'unknown operation'
end
