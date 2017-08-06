#!/usr/bin/ruby
require_relative "../common/selenium"
require_relative "../common/db"
require_relative "../helper/common"

def unfollow user, followers_count, following_count
  login user

  driver.navigate.to "https://www.instagram.com/#{user}/"

  Selenium::WebDriver::Wait.new(timeout: 20).until {
    driver.find_element(xpath: "//a[@href=\"/#{name}/followers/\"]").click
  }
  sleep 1

  followers = []
  scroll_user_list(0, followers_count) { |name|
    return followers.push name if !followers.include? name
    false
  }

  driver.find_element(xpath: "//button[text()=\"Close\"]").click
  sleep 1
  Selenium::WebDriver::Wait.new(timeout: 20).until {
    driver.find_element(xpath: "//a[@href=\"/#{name}/followers/\"]").click
  }
  sleep 1

  scroll_user_list(0, following_count) { |name|
    puts name if followers.include? name
    true
  }

  driver.find_element(xpath: "//button[text()=\"Close\"]").click

  driver.close
end
