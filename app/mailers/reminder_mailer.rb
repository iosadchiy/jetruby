class ReminderMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.reminder_mailer.remind_email.subject
  #
  def remind_email
    @reminder = params[:reminder]
    @appointment = @reminder.appointment

    mail to: @appointment.remind_email,
      subject: I18n.t('reminder_mailer.remind_email.subject',
        title: @appointment.title,
        starts_at: I18n.l(@appointment.starts_at, format: :short))
  end
end
