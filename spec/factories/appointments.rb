# == Schema Information
#
# Table name: appointments
#
#  id         :bigint(8)        not null, primary key
#  starts_at  :datetime
#  state      :integer
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_appointments_on_starts_at  (starts_at)
#

FactoryBot.define do
  factory :appointment do
    title { Faker::RickAndMorty.quote }
    state :confirmed
    starts_at {
      t = Appointment.order(starts_at: :desc).pluck(:starts_at).first
      t ? t+1.hour : Time.current
    }
  end
end
