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

def get_public_non_engaged user, limit
  db.query("select f.name, f.lang
            from followers as f
            left join engagement as e on e.follower = f.name and e.user = '#{user}'
            where e.id IS NULL and
            f.type = 'public' and
            f.status = 'typed'
            limit #{limit}")
end

def record_public_engagement user, name
  record_engagement user, name, 'pb.v1'
end

def record_engagement user, name, type
  db.query("insert into engagement(user,follower,type,time) values('#{user}','#{name}','#{type}',NOW())")
end

def get_engagement user, name
  db.query("select * from engagement where user='#{user}' and follower='#{name}'")
end

def get_untyped_followers limit
  db.query("select * from followers where type IS NULL limit #{limit}")
end

def update_follower_type name, type
  db.query("update followers set type=\"#{type}\", status=\"typed\" where name=\"#{name}\"")
end

def create_new_follower follower, source, category, ignore_dups=true
  begin
    db.query("insert into followers values ('#{follower}', NULL, 'new', '#{source}', '#{category}')")
    true
  rescue Mysql2::Error
    raise if !ignore_dups
    record = db.query("select source from followers where name='#{follower}'").first
    new_source = record['source'] + "|#{source}"
    db.query("update followers set source='#{new_source}' where name='#{follower}'")
    false
  end
end
