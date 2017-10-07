#!/usr/bin/ruby
require_relative "../common/selenium"
require_relative "../helper/common"

def likelatest user
  login user
  t = tag
  puts t
  driver.navigate.to "https://www.instagram.com/explore/tags/#{t}/"

  element = driver.find_elements(xpath: '//article//a')[9..20].map { |photo|
    photo.attribute("href").to_s
  }.each { |link| like link }

  driver.close
end

def tag
  ['lovetravel','nomad','adventuretime', 'travel', 'like4like', 'adventure', 'goodtime']
  .sample
end
