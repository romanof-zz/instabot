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

def get_untyped_followers limit
  db.query("select * from followers where type IS NULL limit #{limit}")
end

def update_follower_type name, type
  db.query("update followers set type=\"#{type}\", status=\"typed\" where name=\"#{name}\"")
end

def create_new_follower follower, ignore_dups=true
  begin
    db.query("insert into followers values ('#{follower}', NULL, 'new')")
    true
  rescue Mysql2::Error
    raise if !ignore_dups
    false
  end
end
