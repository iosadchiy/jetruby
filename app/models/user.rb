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

class User < ApplicationRecord
  has_many :appointments

  validates :api_key, presence: true, uniqueness: true

  before_validation :ensure_api_key

  def ensure_api_key
    self.api_key = SecureRandom.uuid.gsub("-", "") unless self.api_key.present?
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_initialize.tap do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      user.save!
    end
  end
end
