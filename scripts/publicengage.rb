#!/usr/bin/ruby
require_relative "../common/selenium"
require_relative "../common/db"
require_relative "../helper/common"

def comment lang, num
  if @comments.nil?
    @comments = {
      :rus => ["круто!","прикольно!","класс!","отличный кадр!","здорово!","ухты!","кайф!","вау!","ммм!"],
      :crazy => ["юпитер!","васильковый ягупоп!","лавандаааа, горная лаванда...","звезда летит, загадывай желание!","кря","ляпотааа","что же делать?!","уиииииии"]
    }
  end
  @comments[lang.to_sym][num]
end

def publicengage user, lang
  login user

  get_public_non_engaged(user, 5).each do |record|
    name = record["name"]

    driver.navigate.to "https://www.instagram.com/#{name}/"

    photos = nil
    Selenium::WebDriver::Wait.new(timeout: 20).until {
      photos = driver.find_elements(xpath: "//main//article/div//a[//img]")
    }

    links = []
    photos.first(9).each do |photo|
      photo.click
      likes_num = 0
      begin
        Selenium::WebDriver::Wait.new(timeout: 20).until {
          elem = driver.find_element xpath: "//section/div/span/span"
          likes_num = elem.text.to_i
        }
      rescue Selenium::WebDriver::Error::TimeOutError
      end
      links << { :num => likes_num, :link => photo.attribute("href").to_s }
      driver.find_element(xpath: "//button[text()=\"Close\"]").click
    end
    links.sort! { |ph1, ph2| ph2[:num] <=> ph1[:num] }
    links = links.first(3).reverse.map! {|l| l[:link]}

    links.each do |link|
      puts link
      driver.navigate.to link

      Selenium::WebDriver::Wait.new(timeout: 60).until { driver.find_element(xpath: "//main//article//img") }

      begin
        driver.find_element(xpath: "//article//span[contains(@class, \"coreSpriteHeartOpen\")]").click
      rescue Selenium::WebDriver::Error::NoSuchElementError
      end
    end

      text = nil
      begin
        Selenium::WebDriver::Wait.new(timeout: 60).until {
          text = driver.find_element(xpath: "//form/textarea")
        }
      rescue  Selenium::WebDriver::Error::TimeOutError
      end
      unless text.nil?
        text.send_keys comment(lang, rand(0..8))
        text.submit
      end

    record_public_engagement user, name
  end

  driver.close
end
