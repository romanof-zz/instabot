export PATH=$PATH:/home/ubuntu/.rvm/rubies/ruby-2.3.3/bin/
export GEM_HOME=/home/ubuntu/.rvm/gems/ruby-2.3.3
export PATH=$PATH:/usr/local/bin
export DISPLAY=:0
# export RUBY_HEAP_MIN_SLOTS=600000
# export RUBY_GC_HEAP_INIT_SLOTS=600000
# export RUBY_GC_MALLOC_LIMIT=59000000
# export RUBY_FREE_MIN=100000
# export RUBY_GC_HEAP_FREE_SLOTS=100000

ruby console.rb --operation=settypes
ruby console.rb --operation=likelatest --asUser=roman0f
ruby console.rb --operation=privateengage --asUser=roman0f
ruby console.rb --operation=publicengage --asUser=roman0f
ruby console.rb --operation=requestfollow --asUser=roman0f
ruby console.rb --operation=likelatest --asUser=yulyassana
ruby console.rb --operation=privateengage --asUser=yulyassana
ruby console.rb --operation=publicengage --asUser=yulyassana
ruby console.rb --operation=requestfollow --asUser=yulyassana

sleep 10m
sh runner.sh >> app.log 2>&1
