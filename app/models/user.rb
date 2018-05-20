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
  has_one :api_stat, autosave: true

  validates :api_key, presence: true, uniqueness: true
  validates :api_stat, presence: true

  before_validation :ensure_api_key, :ensure_api_stat

  def ensure_api_key
    self.api_key = SecureRandom.uuid.gsub("-", "") unless self.api_key.present?
  end

  def ensure_api_stat
    self.api_stat ||= build_api_stat
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

  def self.from_authorization_header(authorization_header)
    if authorization_header =~ /^Token token=(.*)$/
      User.find_by(api_key: $1)
    end
  end

  def appointments_by_date(date)
    t = Time.zone.parse(date)
    self.appointments.where("starts_at >= timestamp ?\
      AND starts_at < timestamp ? + interval '1 day'", t, t)
  end
end
