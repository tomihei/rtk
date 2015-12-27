class TopiceraseJob < ActiveJob::Base
  queue_as :default

  def perform(message)
    gid = message[:group_id]
    newtime = message[:time]
    $rediscont.rpush gid,message
    $redistopic.hincrby(gid,"rescount",1)
    $redistopic.hset(gid,"lastpost",newtime)
  end
end
