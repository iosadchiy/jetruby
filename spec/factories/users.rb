# == Schema Information
#
# Table name: users
#
#  id               :bigint(8)        not null, primary key
#  api_key          :string
#  email            :string
#  oauth_expires_at :datetime
#  oauth_token      :string
#  provider         :string
#  uid              :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_users_on_api_key           (api_key) UNIQUE
#  index_users_on_uid_and_provider  (uid,provider) UNIQUE
#

FactoryBot.define do
  factory :user do
    provider "google_oauth2"
    uid { SecureRandom.uuid }
    email { Faker::Internet.email }
    oauth_token { SecureRandom.uuid }
    oauth_expires_at { 1.hour.from_now }
  end
end
