#!/usr/bin/ruby
require_relative "../common/selenium"
require_relative "../common/db"
require_relative "../helper/common"

def getfollowers user, source_account
  login user

  driver.navigate.to "https://www.instagram.com/#{source_account}/"

  Selenium::WebDriver::Wait.new(timeout: 20).until { driver.find_element(xpath: "//a[@href=\"/#{source_account}/followers/\"]") }
  driver.find_element(xpath: "//a[@href=\"/#{source_account}/followers/\"]").click
  sleep 5

  scroll_user_list(0, 0, nil) { |name| create_new_follower(name, source_account, 'travel', 'rus') }

  driver.close
end
