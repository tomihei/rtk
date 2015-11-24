Resque.redis = $backjob
Resque.after_fork = Proc.new { ActiveRecord::Base.establish_connection }
