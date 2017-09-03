#!/usr/bin/ruby
require "aws-sdk-ec2"
require_relative 'common/config'

ec2 = Aws::EC2::Client.new(
  region: config['aws']['region'],
  credentials: Aws::Credentials.new(config['aws']['access'], config['aws']['secret']))

oldip = ec2.describe_addresses.addresses.first
puts "old ip: #{oldip.public_ip}"

newip = ec2.allocate_address
puts "new ip: #{newip.public_ip}"

ec2.associate_address instance_id: config['aws']['instance_id'], public_ip: newip.public_ip

ec2.release_address allocation_id: oldip.allocation_id
