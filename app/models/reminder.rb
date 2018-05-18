# == Schema Information
#
# Table name: reminders
#
#  id             :bigint(8)        not null, primary key
#  minutes_before :integer
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
  belongs_to :appointment

  validates :minutes_before, presence: true,
    numericality: {only_integer: true, greater_than_or_equal_to: 0}
end
