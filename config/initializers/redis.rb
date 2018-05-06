if ENV["REDISTOGO_URL"]
  $redistopic = Redis.new(url:ENV["REDISTOGO_URL"],driver:"hiredis")
else
  $redistopic = Redis.new(:host => "localhost",:port => 6379,:db => 0,:driver => "hiredis")
end

if ENV["REDISCLOUD_URL"]
  $rediscont = Redis.new(url:ENV["REDISCLOUD_URL"],driver:"hiredis")

else
  $rediscont  = Redis.new(:host => "localhost", :port => 6379 ,:db => 1,:driver => "hiredis") 
end

if ENV["REDIS_URL"]
  $backjob = Redis.new(url:ENV["REDIS_URL"],driver:"hiredis")
  $visitor = Redis.new(url: "redis://h:pdk3gv38r00k87t1p185ngcler@ec2-54-235-101-32.compute-1.amazonaws.com:6619",driver:"hiredis")
else
  $backjob = Redis.new(:host => "localhost", :port => 6379,:db => 2,:driver => "hiredis")
  $visitor = Redis.new(:host => "localhost", :port => 6379,:db => 3,:driver => "hiredis")
end

