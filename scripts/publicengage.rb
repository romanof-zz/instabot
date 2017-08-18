#!/usr/bin/ruby
require_relative "../common/selenium"
require_relative "../common/db"
require_relative "../helper/common"

def publicengage user
  login user

  public_non_engaged(user, 5).each do |record|
    engage_with_user record["name"], record["lang"]
    record_public_engagement user, record["name"]
  end

  driver.close
end
