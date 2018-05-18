# == Schema Information
#
# Table name: reminders
#
#  id             :bigint(8)        not null, primary key
#  minutes_before :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  appointment_id :bigint(8)
#
# Indexes
#
#  index_reminders_on_appointment_id  (appointment_id)
#
# Foreign Keys
#
#  fk_rails_...  (appointment_id => appointments.id)
#

require 'rails_helper'

RSpec.describe Reminder, type: :model do
  it "factory is valid" do
    expect(build(:reminder)).to be_valid
  end

  it "is always positive" do
    expect(build(:reminder, minutes_before: -1)).to be_invalid
  end
end
