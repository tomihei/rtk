class DatawriteJob < ActiveJob::Base
  queue_as :default

  def perform(message)
    gid = message[:group_id]
    newtime = Time.zone.now.strftime("%Y/%m/%d %H:%M:%S").to_s
    $rediscont.rpush gid,message
    $redistopic.hincrby(gid,"rescount",1)
    $redistopic.hset(gid,"lastpost",newtime)
  end
end
