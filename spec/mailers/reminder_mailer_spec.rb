require "rails_helper"

RSpec.describe ReminderMailer, type: :mailer do
  describe "remind_email" do
    let(:t) { Time.parse("2018-05-19 20:00 +0300") }
    let(:reminder) {
      create :reminder, appointment: create(:appointment, title: "Apt1", starts_at: t)
    }
    let(:mail) { ReminderMailer.with(reminder: reminder).remind_email }

    it "renders the headers" do
      expect(mail.subject).to eq("Appointment \"#{reminder.appointment.title}\" starts on 19 May 20:00")
      expect(mail.to).to eq([reminder.appointment.user.email])
      expect(mail.from).to eq([ENV['DEFAULT_FROM_EMAIL']])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match(reminder.appointment.title)
    end
  end

end
