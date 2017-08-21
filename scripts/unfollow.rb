#!/usr/bin/ruby
require_relative "../common/selenium"
require_relative "../common/db"
require_relative "../helper/common"

def unfollow user
  login user

  begin
    driver.navigate.to "https://www.instagram.com/#{user}/"
  rescue Net::ReadTimeout
    exit "no internet"
  end

  Selenium::WebDriver::Wait.new(timeout: 20).until {
    driver.find_element(xpath: "//main//header//button//img")
  }
  followers_count = driver.find_element(xpath: "//a[contains(@href, 'followers')]/span")
    .text.delete(',').to_i
  driver.find_element(xpath: "//a[@href=\"/#{user}/followers/\"]").click
  sleep 1

  followers = []
  scroll_user_list(0, 0, followers_count-1) { |name|
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
  following_count = driver.find_element(xpath: "//a[contains(@href, 'following')]/span")
    .text.delete(',').to_i
  driver.find_element(xpath: "//a[@href=\"/#{user}/following/\"]").click
  sleep 1

  following = []
  scroll_user_list(0, 0, following_count-1) { |name|
    incl = !following.include?(name)
    following.push name if incl
    incl
  }

  removelist = []
  following.each do |name|
    removelist.push name if !followers.include?(name) && unfollowable?(user, name)
  end
  removelist.reverse!

  puts removelist
  exit

  removelist.first(15).each do |name|
    puts name
    driver.find_element(xpath: "//ul/li[contains(.,\"#{name}\")]//button").click
  end

  driver.close
end
