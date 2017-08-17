#!/usr/bin/ruby
require_relative "../common/selenium"
require_relative "../common/db"
require_relative "../helper/common"

def unfollow user
  login user

  driver.navigate.to "https://www.instagram.com/#{user}/"

  Selenium::WebDriver::Wait.new(timeout: 20).until {
    driver.find_element(xpath: "//main//header//button//img")
  }
  followers_count = driver.find_element(xpath: "//a[@href=\"/#{user}/followers/\"]/span")
    .text.delete!(",").to_i
  driver.find_element(xpath: "//a[@href=\"/#{user}/followers/\"]").click
  sleep 1

  followers = []
  scroll_user_list(0, 0, followers_count) { |name|
    incl = !followers.include?(name)
    if incl
      followers.push name
      record_engagement(user, name, "orig.fl") unless get_engagement(user, name).count > 0
    end
    incl
  }

  driver.find_element(xpath: "//button[text()=\"Close\"]").click
  Selenium::WebDriver::Wait.new(timeout: 20).until {
    driver.find_element(xpath: "//main//header//button//img")
  }
  following_count = driver.find_element(xpath: "//a[@href=\"/#{user}/following/\"]/span")
    .text.delete!(",").to_i
  driver.find_element(xpath: "//a[@href=\"/#{user}/following/\"]").click
  sleep 1

  following = []
  scroll_user_list(0, 0, following_count) { |name|
    incl = !following.include?(name)
    following.push name if incl
    incl
  }

  removelist = []
  following.each { |name| removelist.push name if !followers.include?(name) }
  removelist.reverse!

  removelist.first(15).each do |name|
    puts name
    driver.find_element(xpath: "//ul/li[contains(.,\"#{name}\")]//button").click
  end

  driver.close
end
