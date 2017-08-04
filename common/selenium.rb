#!/usr/bin/ruby
require "selenium-webdriver"

def driver
  if @driver.nil?
    # @driver = Selenium::WebDriver.for :remote, url: "http://127.0.0.1:9515", desired_capabilities: :chrome
    Selenium::WebDriver.logger.level = :debug
    Selenium::WebDriver.logger.output = 'selenium.log'

    options = Selenium::WebDriver::Chrome::Options.new
    options.add_argument('--ignore-certificate-errors')
    options.add_argument('--disable-popup-blocking')
    options.add_argument('--disable-translate')
    options.add_argument('--port=9515')
    @driver = Selenium::WebDriver.for :chrome, options: options
  end

  @driver
end
