#!/usr/bin/ruby
require_relative "../common/selenium"
require_relative "../common/db"
require_relative "../helper/common"

def requestfollow user
  login user

  driver.navigate.to "https://www.instagram.com/#{user}/"
  Selenium::WebDriver::Wait.new(timeout: 20).until {
    driver.find_element xpath: "//main//header//button//img"
  }

  followers_count = driver.find_element(xpath: "//a[contains(@href, 'followers')]/span")
    .text.delete(',').to_i
  following_count = driver.find_element(xpath: "//a[contains(@href, 'following')]/span")
    .text.delete(',').to_i

  puts "followers: #{followers_count}, following: #{following_count}"
  exit if (followers_count - following_count) < 100 && following_count < 500

  private_non_engaged(user, 5).each do |record|
    name = record['name']
    puts name

    driver.navigate.to "https://www.instagram.com/#{name}/"

    follow = nil
    begin
      Selenium::WebDriver::Wait.new(timeout: 10).until do
        follow = driver.find_element(xpath: '//button[text()="Follow"]')
      end
    rescue Selenium::WebDriver::Error::NoSuchElementError, , Net::ReadTimeout
      begin
        element = driver.find_element(xpath: "//div/h2")
        update_follower_type(name, 'deleted') if element.text() == "Sorry, this page isn't available."
      rescue Selenium::WebDriver::Error::NoSuchElementError, Net::ReadTimeout
      end
    end

    unless follow.nil?
      follow.click
      record_request_engagement user, name
    end
  end

  driver.close
end
