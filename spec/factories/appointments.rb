# == Schema Information
#
# Table name: appointments
#
#  id         :bigint(8)        not null, primary key
#  ends_at    :datetime
#  starts_at  :datetime
#  state      :integer
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :appointment do
    title { Faker::RickAndMorty.quote }
    state :confirmed
    starts_at { Time.now + 1.hour }
    ends_at { Time.now + 2.hours }
  end
end
