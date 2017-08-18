#!/usr/bin/ruby
require_relative 'common/args'
require_relative 'scripts/getfollowers'
require_relative 'scripts/settypes'
require_relative 'scripts/likelatest'
require_relative 'scripts/unfollow'
require_relative 'scripts/publicengage'
require_relative 'scripts/requestfollow'
require_relative 'scripts/privateengage'

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
  publicengage options[:username]
when :requestfollow
  requestfollow options[:username]
when :privateengage
  privateengage options[:username]
else
  puts 'unknown operation'
end
