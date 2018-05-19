require 'rails_helper'

RSpec.describe RemindJob, type: :job do
  it "issues a reminder" do
    reminder = instance_double(Reminder)
    expect(reminder).to receive(:remind!)
    RemindJob.perform_now(reminder)
  end
end
