if ENV["REDISTOGO_URL"]
  $redistopic = Redis.new(url:ENV["REDISTOGO_URL"])
else
  $redistopic = Redis.new(:host => "localhost",:port => 6379,:db => 0,:driver => "hiredis")
end

if ENV["REDISCLOUD_URL"]
  $rediscont  = Redis.new(url:ENV["REDISCLOUD_URL"])
else
  $rediscont  = Redis.new(:host => "localhost", :port => 6379 ,:db => 1,:driver => "hiredis") 
end

if ENV["REDIS_URL"]
  $backjob = Redis.new(url:ENV["REDIS_URL"])
else
  $backjob = Redis.new(:host => "localhost", :port => 6379,:db => 2,:driver => "hiredis")
end
