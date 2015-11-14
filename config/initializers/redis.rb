if ENV["REDIS_URL"]
  $redistopic = Redis.new(url:ENV["REDIS_URL"])
else
  $redistopic = Redis.new(:host => "ec2-54-83-32-60.compute-1.amazonaws.com",:port => 18399, :password => "p605eheec3rg219n983prrj3baq")
end

if ENV["REDISCLOUD_URL"]
  $rediscont  = Redis.new(url:ENV["REDISCLOUD_URL"])
else
  $rediscont = Redis.new(:host => "pub-redis-14162.us-east-1-2.4.ec2.garantiadata.com"  , :port => 14162 , :password => "PGjUZkCa9yo1D7q5")
end

