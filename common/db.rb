#!/usr/bin/ruby
require "mysql2"
require_relative "config"

def db
  if @db.nil?
    @db = client = Mysql2::Client.new(
      host: config["db"]["host"],
      username: config["db"]["username"],
      password: config["db"]["password"],
      database: config["db"]["database"])
  end

  @db
end

def create_new_follower follower, ignore_dups=true
  begin
    db.query("insert into followers values ('#{follower}', NULL, 'new')")
  rescue Mysql2::Error
    raise if !ignore_dups
  end
end
