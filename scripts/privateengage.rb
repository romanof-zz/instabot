#!/usr/bin/ruby
require_relative "../common/selenium"
require_relative "../common/db"
require_relative "../helper/common"

def privateengage user
  login user

  count = 0
  private_requested(user).each do |record|
    break if count == 2
    result = engage_with_user record['follower'], record["lang"]
    if result
      record_private_engagement user, record['follower']
      count+=1
    end
  end

  driver.close
end
