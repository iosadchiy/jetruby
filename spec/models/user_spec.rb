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

require 'rails_helper'

RSpec.describe User, type: :model do
  describe "self.from_omniauth" do
    let(:auth) { build_auth }

    it "creates a new user" do
      expect{User.from_omniauth(auth)}.to change{User.count}.by(1)
      expect(User.find_by(uid: auth.uid, provider: auth.provider)).to be_present
    end

    it "updates user" do
      u = create(:user, uid: auth.uid, provider: auth.provider, email: "vasya@example.com")
      expect{User.from_omniauth(auth)}.to change{u.reload.email}.from("vasya@example.com").to("test@example.com")
    end
  end
end
