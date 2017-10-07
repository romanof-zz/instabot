#!/usr/bin/ruby
require_relative "../common/config"
require_relative "../common/selenium"

def ref_to_name ref
  ref.to_s[26..-2]
end

def login user
  begin
    driver.navigate.to "https://www.instagram.com/accounts/login/"
  rescue Net::ReadTimeout
    fail "login_internet"
  end

  Selenium::WebDriver::Wait.new(timeout: 5).until do
    driver.find_element(xpath: "//form")
  end

  username = driver.find_element(xpath: '//form//input[@name="username"]')
  username.send_keys user

  password = driver.find_element(xpath: '//form//input[@name="password"]')
  password.send_keys config['accounts'][user]

  submit = driver.find_element(xpath: '//form//button')
  submit.submit

  begin
    Selenium::WebDriver::Wait.new(timeout: 5).until { driver.find_element xpath: "//main/section" }
  rescue Selenium::WebDriver::Error::TimeOutError, Net::ReadTimeout
    fail "login_mainscreen"
  end

  puts "Logged in as #{user}!"
end

def scroll_user_list count, error, limit, &block
  return if !limit.nil? && count.to_i >= limit.to_i
  sleep 300 if (count.to_i % 500 == 0) && count.to_i != 0

  original_count = count

  begin
    new_list = nil
    Selenium::WebDriver::Wait.new(timeout: 5).until do
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
    sleep 2 ** error
    exit if error > 10
  else
    error = 0
  end

  puts "count: #{count}, limit: #{limit}"
  scroll_user_list count, error, limit, &block
end

def engage_with_user name, lang, expected_type
  begin
    driver.navigate.to "https://www.instagram.com/#{name}/"
  rescue Net::ReadTimeout
    fail "engage_#{name}"
    return false
  end

  begin
    element = driver.find_element(xpath: "//main/article/div/div/h2")
    if element.text() == "This Account is Private"
      update_follower_type name, 'private' if expected_type == 'public'
      return false
    end
  rescue Selenium::WebDriver::Error::NoSuchElementError
  end

  photos = nil
  Selenium::WebDriver::Wait.new(timeout: 60).until {
    photos = driver.find_elements(xpath: "//main//article/div//a[//img]")
  }

  links = []
  puts "engaging user: #{name} with photo count: #{photos.count}"
  return true unless photos.count

  photos.first(9).each do |photo|
    likes_num = 0
    driver.action.move_to(photo).perform
    begin
      Selenium::WebDriver::Wait.new(timeout: 1).until {
        likes_num = driver.find_element(xpath: "//main//article/div//a//ul/li[1]/span[1]")
          .text.delete(',').to_i
      }
    rescue Selenium::WebDriver::Error::TimeOutError
    end
    links << { :num => likes_num, :link => photo.attribute("href").to_s }
  end
  links.sort! { |ph1, ph2| ph2[:num] <=> ph1[:num] }
  links = links.first(3).shuffle.map! {|l| l[:link]}

  links.each { |link| like link }

  text = nil
  begin
    Selenium::WebDriver::Wait.new(timeout: 5).until {
      text = driver.find_element(xpath: "//form/textarea")
    }
  rescue  Selenium::WebDriver::Error::TimeOutError
  end
  unless text.nil?
    text.send_keys comment(lang, rand(0..8))
    text.submit
  end

  true
end

def like link
  puts link
  driver.navigate.to link
  Selenium::WebDriver::Wait.new(timeout: 5).until { driver.find_element(xpath: "//main//article//img") }
  driver.action.double_click(driver.find_element(xpath: "//article/div//img")).perform
end

def fail error
  driver.save_screenshot "screenshots/#{error}_#{Time.now.to_i}.png" if driver
  puts "error: #{error}"
  exit
end

def comment lang, num
  if @comments.nil?
    @comments = {
      :rus => ["круто!","прикольно!","класс!","отличный кадр!","здорово!"]
    }
  end
  @comments[lang.to_sym][num]
end
