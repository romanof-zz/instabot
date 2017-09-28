#!/usr/bin/ruby
require_relative "../common/selenium"
require_relative "../common/db"
require_relative "../helper/common"

def requestfollow user
  login user

  private_non_engaged(user, 5).each do |record|
    print "#{record['name']} - "

    begin
      driver.navigate.to "https://www.instagram.com/#{record['name']}/"
    rescue Net::ReadTimeout
      next
      puts "skipped due to poor connection"
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
        puts 'deleted'
      rescue Selenium::WebDriver::Error::TimeOutError
      end
    end

    unless follow.nil?
      follow.click
      record_request_engagement user, name
      puts 'requested'
    end
  end

  driver.close
end
