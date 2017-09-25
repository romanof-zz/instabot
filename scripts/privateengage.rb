#!/usr/bin/ruby
require_relative "../common/selenium"
require_relative "../common/db"
require_relative "../helper/common"

def privateengage user
  login user

  private_requested(user).each do |record|
    result = engage_with_user record['follower'], record["lang"], 'private'
    if result
      update_private_engagement_type user, record['follower'], 'pr.v1'
      driver.find_element(xpath: "//header//button[text()='Following']").click
    else
      begin
        driver.find_element(xpath: "//header//button[text()='Follow']")
        update_private_engagement_type user, record['follower'], 'pr.fld'
      rescue Selenium::WebDriver::Error::NoSuchElementError
        if record['time'] < (Time.now - 3600*24)
          begin
            driver.find_element(xpath: "//header//button[text()='Requested']").click
            update_private_engagement_type user, record['follower'], 'pr.fld'
          rescue Selenium::WebDriver::Error::NoSuchElementError
          end
        end
      end
    end
  end

  driver.close
end
