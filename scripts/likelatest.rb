#!/usr/bin/ruby
require_relative "../common/selenium"
require_relative "../helper/common"

def likelatest user, tag
  login user
  driver.navigate.to "https://www.instagram.com/explore/tags/#{tag}/"
  sleep 3

  index = 0
  prev = nil
  driver.find_elements(xpath: '//article//a//img').each do |photo|
    driver.action.click_and_hold(prev).move_to(photo).release.perform unless prev.nil?
    next if index < 9 && index > 20

    photo.click
    sleep 2

    begin
      driver.find_element(xpath: "//article//span[contains(@class, \"coreSpriteHeartOpen\")]").click
      puts "Liked"
    rescue Selenium::WebDriver::Error::NoSuchElementError
      puts "Skipped"
    end

    driver.find_element(xpath: "//button[contains(text(),'Close')]").click
    prev = photo
    index+=1
  end

  driver.close
end
