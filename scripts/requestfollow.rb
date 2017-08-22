#!/usr/bin/ruby
require_relative "../common/selenium"
require_relative "../common/db"
require_relative "../helper/common"

def requestfollow user
  login user

  begin
    driver.navigate.to "https://www.instagram.com/#{user}/"
  rescue Net::ReadTimeout
    puts "no internet"
    exit
  end

  Selenium::WebDriver::Wait.new(timeout: 5).until {
    driver.find_element xpath: "//main//header//button//img"
  }

  followers_count = driver.find_element(xpath: "//a[contains(@href, 'followers')]/span")
    .text.delete(',').to_i
  following_count = driver.find_element(xpath: "//a[contains(@href, 'following')]/span")
    .text.delete(',').to_i

  puts "followers: #{followers_count}, following: #{following_count}"
  exit if (followers_count - following_count) < 100 && following_count < 500

  private_non_engaged(user, 2).each do |record|
    name = record['name']
    puts name

    begin
      driver.navigate.to "https://www.instagram.com/#{name}/"
    rescue Net::ReadTimeout
      next
    end

    follow = nil
    begin
      Selenium::WebDriver::Wait.new(timeout: 5).until do
        follow = driver.find_element(xpath: '//button[text()="Follow"]')
      end
    rescue Selenium::WebDriver::Error::TimeOutError
      begin
        element = driver.find_element(xpath: "//div/h2")
        update_follower_type(name, 'deleted') if element.text() == "Sorry, this page isn't available."
      rescue Selenium::WebDriver::Error::TimeOutError
      end
    end

    unless follow.nil?
      follow.click
      record_request_engagement user, name
    end
  end

  driver.close
end
