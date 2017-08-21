#!/usr/bin/ruby
require_relative "../common/selenium"
require_relative "../helper/common"

def likelatest user
  login user

  Selenium::WebDriver::Wait.new(timeout: 5).until { driver.find_elements(xpath: '//article//section').size > 10 }

  driver.find_elements(xpath: '//article').each_with_index do |post, i|
    Selenium::WebDriver::Wait.new(timeout: 5).until { post.location_once_scrolled_into_view }

    header_link = nil
    Selenium::WebDriver::Wait.new(timeout: 5).until do
      header_link = driver.find_element(xpath: "//article[#{i+1}]/header/a")
    end

    follower = ref_to_name header_link.attribute("href")
    print "#{i}. #{follower} - "

    next if follower == user

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
