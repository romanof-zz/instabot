#!/usr/bin/ruby
require_relative "../common/config"
require_relative "../common/selenium"

def ref_to_name ref
  ref.to_s[26..-2]
end

def login user
  driver.navigate.to "https://www.instagram.com/accounts/login/"

  wait = Selenium::WebDriver::Wait.new(timeout: 10) # seconds
  wait.until do
    driver.find_element(xpath: "//form")
  end

  username = driver.find_element(xpath: '//form//input[@name="username"]')
  username.send_keys user

  password = driver.find_element(xpath: '//form//input[@name="password"]')
  password.send_keys config['accounts'][user]

  submit = driver.find_element(xpath: '//form//button')
  submit.submit

  Selenium::WebDriver::Wait.new(timeout: 60).until { @driver.find_element id: "mainFeed" }

  puts "Logged in as #{user}!"
end
