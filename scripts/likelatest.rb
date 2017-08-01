#!/usr/bin/ruby
require_relative "../common/selenium"
require_relative "../helper/auth"

def likelatest user
  login user

  Selenium::WebDriver::Wait.new(timeout: 60).until { driver.find_elements(xpath: '//article//section').size > 10 }

  driver.find_elements(xpath: '//article').each_with_index do |post, i|
    Selenium::WebDriver::Wait.new(timeout: 10).until { post.location_once_scrolled_into_view }

    header_link = nil
    Selenium::WebDriver::Wait.new(timeout: 60).until do
      header_link = driver.find_element(xpath: "//article[#{i+1}]//header/div/a")
    end
    print i.to_s + ". " + header_link.attribute("href").to_s + " - "

    begin
      like = driver.find_element(xpath: "//article[#{i+1}]//span[contains(@class, \"coreSpriteHeartOpen\")]")
      like.click
      puts "Liked"
    rescue Selenium::WebDriver::Error::NoSuchElementError
      puts "Skipped"
    end
  end

  driver.close
end
