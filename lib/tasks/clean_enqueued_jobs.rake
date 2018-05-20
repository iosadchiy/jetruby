task :clear_enqueued_jobs do
  require 'sidekiq/api'

  Sidekiq::Queue.new("default").clear
  Sidekiq::Queue.new("mailers").clear
  Sidekiq::RetrySet.new.clear
  Sidekiq::ScheduledSet.new.clear
end
