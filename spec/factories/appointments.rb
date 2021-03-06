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
#  user_id    :bigint(8)
#
# Indexes
#
#  index_appointments_on_starts_at            (starts_at)
#  index_appointments_on_state_and_starts_at  (state,starts_at)
#  index_appointments_on_user_id              (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

FactoryBot.define do
  factory :appointment do
    user { User.last || create(:user) }
    title { Faker::RickAndMorty.quote + SecureRandom.uuid }
    state :confirmed
    starts_at {
      t = Appointment.order(starts_at: :desc).pluck(:starts_at).first
      t ? t+1.hour : 1.minute.since
    }

    factory :appointment_with_reminders do
      transient { reminders_count 1 }
      after(:create) do |appointment, eva|
        create_list(:reminder, eva.reminders_count, appointment: appointment)
        appointment.reload
      end
    end
  end
end
