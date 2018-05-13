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

require 'rails_helper'

RSpec.describe Appointment, type: :model do
  it "factory is valid" do
    expect(build(:appointment)).to be_valid
  end

  xit "does not allow clashes" do
    t = Time.now+1.hour
    create(:appointment, starts_at: t)

    expect(build(:appointment, starts_at: t-59.minutes)).to be_invalid
    expect(build(:appointment, starts_at: t+59.minutes)).to be_invalid
  end

  it "lasts for 1 hour" do
    a = build(:appointment, starts_at: Time.now)
    expect(a.ends_at - a.starts_at).to eql 1.hour.to_f
  end
end
