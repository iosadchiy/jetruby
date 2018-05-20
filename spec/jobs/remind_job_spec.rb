require 'rails_helper'

RSpec.describe RemindJob, type: :job do
  include ActiveJob::TestHelper

  it "issues a reminder" do
    reminder = create(:reminder)
    expect(Reminder.need_to_be_sent_at(Time.current)).to include(reminder)
    RemindJob.perform_now
    expect(reminder.reload).to be_sent
  end
end
