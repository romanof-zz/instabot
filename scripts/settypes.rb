#!/usr/bin/ruby
require_relative "../common/selenium"
require_relative "../common/db"

def set_follower_types
  get_untyped_followers(10).each do |follower|
    name = follower["name"]
    driver.navigate.to "https://www.instagram.com/#{name}/"
    Selenium::WebDriver::Wait.new(timeout: 30).until { driver.find_element(xpath: "//main//div//img") }

    type = false
    type = "private" if driver.find_element(xpath: "//main/article/div/h2")
    type = "public" if driver.find_element(xpath: "//main//div//a//img")
    puts " #{name} - #{type}"

    if type
      update_follower_type name, type
    end
  end
end
