export PATH=$PATH:/home/ubuntu/.rvm/rubies/ruby-2.3.3/bin/
export GEM_HOME=/home/ubuntu/.rvm/gems/ruby-2.3.3
export PATH=$PATH:/usr/local/bin

pkill -f runner
pkill -f ruby
sh runner.sh >> app.log 2>&1 &
ruby ipswap.rb
