(use "git push" to publish your local commits)
export PATH=$PATH:/home/ubuntu/.rvm/rubies/ruby-2.3.3/bin/
export GEM_HOME=/home/ubuntu/.rvm/gems/ruby-2.3.3
export PATH=$PATH:/usr/local/bin
export DISPLAY=:0

ruby console.rb --operation=unfollow --followers=253 --following=190 --asUser=roman0f
