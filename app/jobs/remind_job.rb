class RemindJob < ApplicationJob
  queue_as :default

  def perform(reminder)
    reminder.remind!
  end
end
