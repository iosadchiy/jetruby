# == Schema Information
#
# Table name: reminders
#
#  id             :bigint(8)        not null, primary key
#  minutes_before :integer
#  state          :integer          default("pending")
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  appointment_id :bigint(8)
#
# Indexes
#
#  index_reminders_on_appointment_id            (appointment_id)
#  index_reminders_on_appointment_id_and_state  (appointment_id,state)
#
# Foreign Keys
#
#  fk_rails_...  (appointment_id => appointments.id)
#

require 'rails_helper'

RSpec.describe Reminder, type: :model do
  include ActiveJob::TestHelper

  let(:t) { 1.minute.since }
  let(:reminder) {
    create(:reminder, minutes_before: 1, appointment: create(:appointment, starts_at: t))
  }

  it "factory is valid" do
    expect(build(:reminder)).to be_valid
  end

  it "is always positive" do
    expect(build(:reminder, minutes_before: -1)).to be_invalid
  end

  it "is pending initially" do
    expect(build(:reminder)).to be_pending
  end

  it "can be rescheduled" do
    r = create(:reminder, state: :sent, appointment: create(:appointment, starts_at: 20.minutes.since))
    expect{r.update(minutes_before: 15)}
      .to change{r.state.to_sym}.from(:sent).to(:pending)
  end

  describe '#remind_at' do
    it "calculates the time to remind" do
      t = 2.hours.since
      r = build(:reminder, minutes_before: 1,
        appointment: build(:appointment, starts_at: t))
      expect(r.remind_at).to eql(t - 1.minute)
    end
  end

  describe "#remind!" do
    it "sends an email" do
      perform_enqueued_jobs do
        expect{reminder.remind!}.to change{ActionMailer::Base.deliveries.size}.by(1)
      end
    end

    it "does nothing if reminder's been already sent" do
      reminder.sent!
      assert_enqueued_jobs 0 do
        reminder.remind!
      end
    end

    it "does nothing if the time has not come yet" do
      t = 2.minutes.since
      reminder.appointment.update(starts_at: t)
      expect{reminder.remind!}.not_to change{reminder.reload}
    end

    it "marks reminder as sent on success" do
      expect{reminder.remind!}.to change{reminder.state.to_sym}.from(:pending).to(:sent)
    end
  end


  describe "scope need_to_be_sent_at(time)" do
    it "selects on conditions: appointment is upcoming and confirmed,
      reminder is pending and on time" do
        t = 1.minute.since
        a_past = create(:appointment_with_reminders, starts_at: 1.hour.before(t), reminders_count: 1)
        a_canceled = create(:appointment_with_reminders, state: :canceled, reminders_count: 1)
        a_pending = create(:appointment_with_reminders, state: :pending, reminders_count: 1)
        a_good = create(:appointment, starts_at: 10.minutes.since(t))
        r1 = create(:reminder, appointment: a_good, minutes_before: 9)
        r2 = create(:reminder, appointment: a_good, minutes_before: 11)

        expect(Reminder.need_to_be_sent_at(t)).to match_array [r2]
      end
  end
end
