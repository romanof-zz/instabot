#!/usr/bin/ruby
require_relative "../common/selenium"
require_relative "../common/db"
require_relative "../helper/common"

def unfollow user, followers_count, following_count
  login user

  driver.navigate.to "https://www.instagram.com/#{user}/"

  Selenium::WebDriver::Wait.new(timeout: 20).until {
    driver.find_element(xpath: "//main//header//button//img")
  }
  driver.find_element(xpath: "//a[@href=\"/#{user}/followers/\"]").click
  sleep 1

  followers = []
  scroll_user_list(0, followers_count) { |name|
    incl = !followers.include?(name)
    followers.push name if incl
    incl
  }

  driver.find_element(xpath: "//button[text()=\"Close\"]").click
  Selenium::WebDriver::Wait.new(timeout: 20).until {
    driver.find_element(xpath: "//main//header//button//img")
  }
  driver.find_element(xpath: "//a[@href=\"/#{user}/following/\"]").click
  sleep 1

  following = []
  scroll_user_list(0, following_count) { |name|
    incl = !following.include?(name)
    following.push name if incl
    incl
  }

  driver.find_element(xpath: "//button[text()=\"Close\"]").click

  following.each do |name|
    puts name if !followers.include?(name)
  end

  driver.close
end
