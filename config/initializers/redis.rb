if ENV["REDISCLOUD_URL"]
   @redis = Redis.new(:uri => ENV["REDISCLOUD_URL"])
end
