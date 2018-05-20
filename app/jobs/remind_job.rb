class RemindJob < ApplicationJob
  queue_as :default

  def perform
    Reminder.send_all_at(Time.current)
  end
end
