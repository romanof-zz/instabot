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

  begin
    Selenium::WebDriver::Wait.new(timeout: 60).until { @driver.find_element id: "mainFeed" }
  rescue Selenium::WebDriver::Error::TimeOutError, Net::ReadTimeout
    puts "Failed to Login! Exiting"
    exit
  end

  puts "Logged in as #{user}!"
end

def scroll_user_list count, error, limit, &block
  return if !limit.nil? && count.to_i >= limit.to_i

  original_count = count

  begin
    new_list = nil
    Selenium::WebDriver::Wait.new(timeout: 20 ).until do
      new_list = driver.find_elements(xpath: "//ul/li[position() >= last()-20]/div/div/a")
    end

    new_list.each do |e|
      name = ref_to_name e.attribute("href")
      count+=1 if block.call(name)
    end

    driver.action
      .click_and_hold(new_list.last)
      .move_to(new_list[10])
      .release.perform

  rescue Selenium::WebDriver::Error::StaleElementReferenceError
    "error loading"
    sleep 1
  end

  if count == original_count
    error += 1
    sleep error
    die("srolling failed") if error > 30
  else
    error = 0
  end

  puts "count: #{count}, limit: #{limit}"
  scroll_user_list count, error, limit, &block
end
