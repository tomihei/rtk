if ENV["REDISTOGO_URL"]
  $redistopic = Redis.new(url:ENV["REDISTOGO_URL"])
else
  $redistopic = Redis.new(:host => "localhost",:port => 6379)
end

if ENV["REDISCLOUD_URL"]
  $rediscont  = Redis.new(url:ENV["REDISCLOUD_URL"])
else
  $rediscont = Redis.new(:host => "pub-redis-14162.us-east-1-2.4.ec2.garantiadata.com"  , :port => 14162 , :password => "PGjUZkCa9yo1D7q5")
end

if ENV["REDIS_URL"]
  $backjob = Redis.new(url:ENV["REDIS_URL"])
else
  $backjob = Redis.new(:host => "localhost", :port => 6379)
end
