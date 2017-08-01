#!/usr/bin/ruby
require_relative "../common/selenium"
require_relative "../common/db"
require_relative "../helper/auth"

def getfollowers user, source_account
  login user

  driver.navigate.to "https://www.instagram.com/#{source_account}/"

  Selenium::WebDriver::Wait.new(timeout: 20).until { driver.find_element(xpath: "//a[@href=\"/#{source_account}/followers/\"]") }
  driver.find_element(xpath: "//a[@href=\"/#{source_account}/followers/\"]").click
  sleep 1

  scroll_followers 0

  driver.close
end

def scroll_followers count
  begin
    new_list = nil
    Selenium::WebDriver::Wait.new(timeout: 20 ).until do
      new_list = driver.find_elements(xpath: "//ul/li[position() >= last()-10]/div/div/a")
    end

    new_list.each do |e|
      follower = e.attribute("href").to_s[26..-2]
      puts follower
      create_new_follower follower
    end

    driver.action
      .click_and_hold(new_list.last)
      .move_to(new_list.first)
      .release.perform

  rescue Selenium::WebDriver::Error::StaleElementReferenceError
    "error loading"
    sleep 1
  end

  # /items/item[position() >= last() - 2] selects the last three item elements
  puts "count: #{count}"
  scroll_followers count + new_list.count
end
