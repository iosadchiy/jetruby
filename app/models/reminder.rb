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
#  index_reminders_on_appointment_id            (appointment_id)
#  index_reminders_on_appointment_id_and_state  (appointment_id,state)
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

  scope :need_to_be_sent_at, ->(time) {
    pending
      .joins(:appointment)
      .where(appointments: {state: :confirmed})
      .where("starts_at >= timestamp ?", time)
      .where("starts_at - minutes_before * interval '1 minute' <= timestamp ?", time)
  }

  after_initialize do
    self.state ||= :pending
  end

  before_save :reschedule!

  def self.send_all_at(time)
    need_to_be_sent_at(time).each do |reminder|
      reminder.remind!
    end
  end

  def reschedule!
    if !state_changed? && minutes_before_changed? &&
      appointment.upcoming_confirmed? && Time.current < remind_at
      self.state = :pending
    end
  end

  def remind!
    return unless needed?
    ReminderMailer.with(reminder: self).remind_email.deliver_later
    sent!
  end

  def time_to_remind?
    Time.current > remind_at-TIME_DELTA
  end

  def needed?
    pending? && appointment.upcoming_confirmed?
  end

  def remind_at
    minutes_before.minutes.before(appointment.starts_at)
  end
end
