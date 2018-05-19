# Preview all emails at http://localhost:3000/rails/mailers/reminder_mailer
class ReminderMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/reminder_mailer/remind_email
  def remind_email
    ReminderMailer.with(reminder: Reminder.offset(rand(Reminder.count)).first).remind_email
  end

end
