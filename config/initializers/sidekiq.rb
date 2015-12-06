Sidekiq.configure_server do |config|
    
  if ENV["REDIS_URL"]
    config.redis = {url:ENV["REDIS_URL"]} 
  else
    config.redis = {:host => "localhost", :port => 6379,:db => 2,:driver => "hiredis"}
  end
  
end
Sidekiq.configure_client do |config|
  if ENV["REDIS_URL"]
    config.redis = {url:ENV["REDIS_URL"]} 
  else
    config.redis = {:host => "localhost", :port => 6379,:db => 2,:driver => "hiredis"}
  end
end
