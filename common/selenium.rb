#!/usr/bin/ruby
require "selenium-webdriver"

def driver
  @driver = Selenium::WebDriver.for :remote, url: "http://127.0.0.1:9515", desired_capabilities: :chrome if @driver.nil?
  @driver
end
