#!/usr/bin/ruby
require_relative "../common/selenium"
require_relative "../helper/common"

def likelatest user
  login user
  t = tag
  puts t
  driver.navigate.to "https://www.instagram.com/explore/tags/#{t}/"
  sleep 3

  element = driver.find_elements(xpath: '//article//a').each_with_index do |photo, index|
    next if index < 9 || index > 20

    begin
      driver.execute_script("arguments[0].scrollIntoView(true);", photo)
      sleep 2
      photo.click
      sleep 2
      driver.find_element(xpath: "//article//span[contains(@class, \"coreSpriteHeartOpen\")]").click
      puts "Liked"
    rescue Selenium::WebDriver::Error::NoSuchElementError, Selenium::WebDriver::Error::UnknownError, Selenium::WebDriver::Error::ElementNotVisibleError
      puts "Skipped"
      next
    end

    driver.find_element(xpath: "//button[contains(text(),'Close')]").click
  end

  driver.close
end

def tag
  ['lovetravel','nomad','adventuretime', 'travel', 'like4like', 'adventure', 'goodtime']
  .sample
end
