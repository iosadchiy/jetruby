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
#  index_reminders_on_appointment_id  (appointment_id)
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

  it "is pending after change" do
    r = create(:reminder, state: :sent, minutes_before: 10)
    r.update(minutes_before: 20)
    expect(r).to be_pending
  end

  describe '#remind_at' do
    it "calculates the time to remind" do
      t = 2.hours.since
      r = build(:reminder, minutes_before: 1,
        appointment: build(:appointment, starts_at: t))
      expect(r.remind_at).to eql(t - 1.minute)
    end
  end

  describe "#schedule!" do
    it "schedules the RemindJob" do
      reminder
      expect(RemindJob).to receive(:set).with(wait_until: 1.minute.before(t)).and_call_original
      assert_enqueued_with(job: RemindJob, args: [reminder]) do
        reminder.schedule!
      end
    end

    it "is called on save" do
      assert_enqueued_with(job: RemindJob) do
        assert_enqueued_jobs 2 do
          create(:reminder).update(minutes_before: 20)
        end
      end
    end
  end

  describe "#remind!" do
    it "sends an email" do
      expect{reminder.remind!}.to change{ActionMailer::Base.deliveries.size}.by(1)
    end

    it "does nothing if reminder's been already sent" do
      reminder.sent!
      assert_enqueued_jobs 0 do
        reminder.remind!
      end
    end

    it "does nothing and reschedules the job if the time has not come yet" do
      t = 2.minutes.since
      reminder.appointment.update(starts_at: t)
      expect(RemindJob).to receive(:set).with(wait_until: 1.minute.before(t)).and_call_original
      assert_enqueued_jobs 1 do
        assert_enqueued_with(job: RemindJob) do
          reminder.remind!
        end
      end
    end

    it "marks reminder as sent on success" do
      expect{reminder.remind!}.to change{reminder.state.to_sym}.from(:pending).to(:sent)
    end
  end
end
