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
# Indexes
#
#  index_appointments_on_starts_at  (starts_at)
#

require 'rails_helper'

RSpec.describe Appointment, type: :model do
  it "factory is valid" do
    expect(build(:appointment)).to be_valid
  end

  it "lasts for 1 hour" do
    a = build(:appointment, starts_at: Time.now)
    expect(a.ends_at - a.starts_at).to eql 1.hour.to_f
  end

  describe "validations" do
    it "does not allow clashes" do
      t = Time.now+1.hour
      create(:appointment, starts_at: t)

      expect(build(:appointment, starts_at: t-59.minutes)).to be_invalid
      expect(build(:appointment, starts_at: t+59.minutes)).to be_invalid
      expect(build(:appointment, starts_at: t-60.minutes)).to be_valid
      expect(build(:appointment, starts_at: t+60.minutes)).to be_valid
    end

    it "requires starts_at to be present and to be a datetime" do
      expect(build(:appointment, starts_at: "")).to be_invalid
      expect(build(:appointment, starts_at: "arstarst")).to be_invalid
      expect(build(:appointment, starts_at: "2018-05-13 20:45")).to be_valid
    end
  end

  describe "#clashes" do
    let(:t) { Time.now }
    let!(:a1) { create(:appointment, starts_at: t)}
    let!(:a2) { create(:appointment, starts_at: t+2.hours)}

    it "can fit into 1 hour gap" do
      a = build(:appointment, starts_at: t+1.hour)
      expect(a.clashes).to be_empty
    end

    it "clashes with one of the appointments" do
      a = build(:appointment, starts_at: t+1.hour-1.second)
      expect(a.clashes.ids).to eql [a1.id]
    end

    it "does not clash with itself" do
      expect(a1.clashes).to be_empty
    end
  end
end
