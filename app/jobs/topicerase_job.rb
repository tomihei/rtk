class TopiceraseJob < ActiveJob::Base
  queue_as :default

  def perform(gid)
    if Topic.exists?(:key => "#{gid}")
      Topic.destroy_all(:key => "#{gid}")
      $residcont.del(gid)
      $visitor.del(gid)
    end
  end
end
