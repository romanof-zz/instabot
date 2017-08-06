#!/usr/bin/ruby
require_relative "../common/selenium"
require_relative "../common/db"
require_relative "../helper/common"

def comment lang, num
  if @comments.nil?
    @comments = {
      :eng => ["nice pic!","looks cool!", "awesome!!!", "great shot!"],
      :rus => ["круто!","прикольно!"]
    }
  end
  @comments[lang.to_sym][num]
end

def publicengage user, lang
  login user

  get_public_non_engaged(user, 1).each do |record|
    # name = record["name"]
    name = "0lga.karavaeva"

    driver.navigate.to "https://www.instagram.com/#{name}/"

    random = rand(2..10)

    puts "getting photos"
    photos = nil
    Selenium::WebDriver::Wait.new(timeout: 26).until {
      photos = driver.find_elements(xpath: "//main//article/div//a[//img]")
    }
    puts "photos count: #{photos.count}"

    links = []
    links.push photos[0].attribute("href").to_s if !photos[0].nil?
    links.push photos[1].attribute("href").to_s if !photos[1].nil?
    links.push photos[random].attribute("href").to_s if !photos[random].nil?

    puts links.inspect

    links.each do |link|
      driver.navigate.to "https://www.instagram.com/#{link}"

      like = nil
      Selenium::WebDriver::Wait.new(timeout: 60).until {
        like = driver.find_element(xpath: "//article//span[contains(@class, \"coreSpriteHeartOpen\")]")
      }
      like.click unless like.nil?
    end

    text = driver.find_element(xpath: "//form/textarea")
    text.send_keys comment(lang, rand(0..comments.size-1))
    text.submit

    record_public_engagement user, name
  end

  driver.close
end
