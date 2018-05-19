require 'rails_helper'

RSpec.describe RemindJob, type: :job do
  include ActiveJob::TestHelper

  it "issues a reminder" do
    reminder = instance_double(Reminder)
    expect(reminder).to receive(:remind!)
    RemindJob.perform_now(reminder)
  end

  it "is scheduled on appointment update" do
    assert_enqueued_jobs 0
    a = create(:appointment_with_reminders, reminders_count: 1)
    assert_enqueued_jobs 1
    a.update(starts_at: 2.hours.since)
    assert_enqueued_jobs 2
  end
end
