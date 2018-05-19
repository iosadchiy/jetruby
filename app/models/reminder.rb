# == Schema Information
#
# Table name: reminders
#
#  id             :bigint(8)        not null, primary key
#  minutes_before :integer
#  state          :integer          default("pending")
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  appointment_id :bigint(8)
#
# Indexes
#
#  index_reminders_on_appointment_id  (appointment_id)
#
# Foreign Keys
#
#  fk_rails_...  (appointment_id => appointments.id)
#

class Reminder < ApplicationRecord
  TIME_DELTA = 30.seconds
  enum state: [:pending, :sent]
  belongs_to :appointment

  validates :minutes_before, presence: true,
    numericality: {only_integer: true, greater_than_or_equal_to: 0}

  after_initialize do
    self.state ||= :pending
  end

  def remind!
    return unless pending? && appointment.upcoming_confirmed?
    schedule! and return unless time_to_remind?
    ReminderMailer.with(reminder: self).remind_email.deliver_later
  end

  def time_to_remind?
    Time.current > remind_at-TIME_DELTA
  end

  def schedule!
    RemindJob.set(wait_until: remind_at).perform_later(self)
  end

  def remind_at
    minutes_before.minutes.before(appointment.starts_at)
  end
end
