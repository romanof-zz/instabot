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

def unfollowable? user, name
  record = db.query("select * from engagement where user='#{user}' and follower='#{name}'").first
  record.nil? ||
  (!["pr.req","orig.fl"].include?(record['type']) &&
   record['time'] < (Time.now - 3600*24*2))
end

def public_non_engaged user, limit
  order = (user == 'roman0f' ? "asc" : 'desc')
  db.query("select f.name, f.lang
            from followers as f
            left join engagement as e on e.follower = f.name and e.user = '#{user}'
            where e.id IS NULL and
            f.type = 'public' and
            f.status = 'typed'
            order by f.name #{order}
            limit #{limit}")
end

def private_requested user
  db.query "select e.*, f.lang
            from engagement as e
            left join followers as f on e.follower = f.name
            where e.type='pr.req' and e.user = '#{user}'"
end

def private_non_engaged user, limit
  order = (user == 'roman0f' ? "asc" : 'desc')
  db.query("select f.name, f.lang
            from followers as f
            left join engagement as e on e.follower = f.name and e.user = '#{user}'
            where e.id IS NULL and
            f.type = 'private' and
            f.status = 'typed'
            order by f.name #{order}
            limit #{limit}")
end

def record_public_engagement user, name
  record_engagement user, name, 'pb.v1'
end

def record_request_engagement user, name
  record_engagement user, name, 'pr.req'
end

def update_private_engagement_type user, name, type
  db.query "update engagement
            set type='#{type}', time=NOW()
            where user='#{user}' and
                  follower='#{name}' and
                  type='pr.req'"
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

def create_new_follower follower, source, category, lang, ignore_dups=true
  begin
    db.query("insert into followers values ('#{follower}', NULL, 'new', '#{source}', '#{category}', '#{lang}')")
    true
  rescue Mysql2::Error
    raise if !ignore_dups
    record = db.query("select source from followers where name='#{follower}'").first
    unless record['source'].include? source
      new_source = record['source'] + "|#{source}"
      db.query("update followers set source='#{new_source}' where name='#{follower}'")
    end
    false
  end
end
