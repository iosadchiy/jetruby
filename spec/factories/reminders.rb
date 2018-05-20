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

FactoryBot.define do
  factory :reminder do
    appointment
    minutes_before 10
  end
end
