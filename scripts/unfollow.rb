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
  followers_count = driver.find_element(xpath: "//a[contains(@href, 'followers')]/span")
    .text.delete(',').to_i
  driver.find_element(xpath: "//a[@href=\"/#{user}/followers/\"]").click
  sleep 1

  followers = []
  # scroll_user_list(0, 0, followers_count-1) { |name|
  while followers.count != followers_count do
    sleep 300
    driver.find_elements(xpath: "//ul/li/div/div/a").each do |e|
      name = ref_to_name e.attribute("href")
      if !followers.include?(name)
        followers.push name
        record_engagement(user, name, "orig.fl") unless get_engagement(user, name).count > 0
      end
    end
    puts "followers count: #{followers.count} - limit: #{followers_count}"
  end

  driver.find_element(xpath: "//button[text()=\"Close\"]").click
  Selenium::WebDriver::Wait.new(timeout: 20).until {
    driver.find_element(xpath: "//main//header//button//img")
  }
  following_count = driver.find_element(xpath: "//a[contains(@href, 'following')]/span")
    .text.delete(',').to_i
  driver.find_element(xpath: "//a[@href=\"/#{user}/following/\"]").click
  sleep 1

  following = []
  while following.count != following_count do
    sleep 300
    driver.find_elements(xpath: "//ul/li/div/div/a").each do |e|
      name = ref_to_name e.attribute("href")
      following.push name if !following.include?(name)
    end
    puts "following count: #{followers.count} - limit: #{followers_count}"
  end

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
