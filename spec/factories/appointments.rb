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

FactoryBot.define do
  factory :appointment do
    title { Faker::RickAndMorty.quote }
    state :confirmed
    starts_at { Time.now + 1.hour }
  end
end
