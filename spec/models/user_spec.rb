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

require 'rails_helper'

RSpec.describe User, type: :model do
  it "factory is valid" do
    expect(build(:user)).to be_valid
  end

  it "requires an api key" do
    expect(create(:user, api_key: "").api_key).to be_present
  end

  it "cannot have two users with the same api key" do
    u = create(:user)
    expect(build(:user, api_key: u.api_key)).to be_invalid
  end

  describe "self.from_omniauth" do
    let(:auth) { build_auth }

    it "creates a new user" do
      expect{User.from_omniauth(auth)}.to change{User.count}.by(1)
      expect(User.find_by(uid: auth.uid, provider: auth.provider)).to be_present
    end

    it "updates user" do
      u = create(:user, email: "vasya@example.com")
      auth.uid = u.uid
      expect{User.from_omniauth(auth)}.to change{u.reload.email}.from("vasya@example.com").to("test@example.com")
    end
  end
end
