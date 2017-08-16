#!/usr/bin/ruby
require "optparse"

def options
  if @hash_options.nil?
    @hash_options = {}
    OptionParser.new do |opts|
      opts.banner = "Usage: insta_like_comment.rb [--username]"
      opts.on('-o [ARG]', '--operation [ARG]', "") do |v|
        @hash_options[:operation] = v
      end
      opts.on('-u [ARG]', '--asUser [ARG]', "") do |v|
        @hash_options[:username] = v
      end
      opts.on('-s [ARG]', '--sourceAccount [ARG]', "") do |v|
        @hash_options[:source_account] = v
      end
      opts.on('-h', '--help', 'Display this help') do
        puts opts
        exit
      end
    end.parse!
  end

  @hash_options
end
