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
    uid "123123"
    email "nobody@nobody.com"
    oauth_token "93874928374098237489"
    oauth_expires_at "2018-05-14 13:25:09"
  end
end
