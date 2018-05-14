# == Schema Information
#
# Table name: users
#
#  id               :bigint(8)        not null, primary key
#  email            :string
#  oauth_expires_at :datetime
#  oauth_token      :string
#  provider         :string
#  uid              :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

FactoryBot.define do
  factory :user do
    provider "google_oauth2"
    uid { SecureRandom.uuid }
    email "test@example.com"
    oauth_token { SecureRandom.uuid }
    oauth_expires_at { 1.hour.from_now }
  end
end
