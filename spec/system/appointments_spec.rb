RSpec.describe "Appointments" do
  before do
    sign_in
  end

  describe "#index" do
    context "no appointments" do
      it "says no results" do
        visit "/appointments"
        expect(page).to have_content "Appointments", "No results"
      end
    end

    context "an appointment exists" do
      let!(:appointment) { create(:appointment) }

      it "shows list of appointments" do
        visit "/appointments"
        expect(page).to have_content appointment.title, count: 1
      end

      it "does not show appointments of others" do
        a = create(:appointment, user: create(:user))
        visit "/appointments"
        expect(page).not_to have_content a.title
      end
    end
  end


  describe "#create" do
    let!(:appointment) { create(:appointment) }

    it "can create an appointment" do
      visit "/appointments/new"
      fill_in "Title", with: "A new appointment"
      fill_in "Starts at", with: Time.current.in(1.day).to_s(:db)
      click_button "Submit"

      expect(current_url).to end_with("/appointments")
      expect(page).to have_content("A new appointment", count: 1)
    end

    it "cannot create a clash" do
      visit "/appointments/new"
      fill_in "Title", with: "A new appointment"
      fill_in "Starts at", with: appointment.starts_at - 59.minutes
      expect{click_button "Submit"}.not_to change{Appointment.count}
      expect(page).to have_content("Starts at cannot clash with other appointments")
      expect(current_url).to end_with("/appointments")
    end
  end

  describe "#edit" do
    let!(:appointment) { create(:appointment) }

    it "can edit the appointment" do
      visit "/appointments/#{appointment.id}/edit"
      fill_in "Title", with: "some new title"
      select "Canceled"
      expect{click_button "Submit"}.not_to change{Appointment.count}
      expect(appointment.reload.title).to eql "some new title"
      expect(appointment.state).to eql "canceled"
      expect(current_url).to end_with("/appointments")
    end
  end

  describe "state" do
    it "does not list pending upcoming appointment twice" do
      appointment = create(:appointment, state: :pending, starts_at: 1.minute.since)
      appointment2 = create(:appointment, state: :pending, starts_at: 1.hour.ago)
      visit "/appointments"
      within(".pending") { expect(page).to have_content appointment.title }
      within(".canceled") { expect(page).to have_content appointment2.title }
      expect(page).to have_content appointment.title, count: 1
      expect(page).to have_content appointment2.title, count: 1
    end
  end

  describe "reminders" do
    it "can create appointments with multiple reminders" do
      visit "/appointments/new"
      fill_in "Title", with: "A new appointment"
      fill_in "Starts at", with: Time.current
      fill_in "appointment_reminders_attributes_0_minutes_before", with: 10
      click_link "add"
      find("#reminders li:last-child input[type=text]").set(20)
      click_button "Submit"

      expect(current_url).to end_with "/appointments"
      expect(Appointment.last.reminders.pluck(:minutes_before)).to match_array([10, 20])
    end

    it "can add reminders while editing an appointment" do
      a = create(:appointment)
      visit edit_appointment_url(a)
      expect(find("#reminders input[type=text]").value).to eql ""
      find("#reminders input[type=text]").set(2)
      click_link("add")
      find("#reminders li:last-child input[type=text]").set(1)
      click_button "Submit"
      expect(current_url).to end_with "/appointments"
      expect(a.reload.reminders.pluck(:minutes_before)).to match_array([1, 2])
    end

    it "can edit reminders" do
      a = create(:appointment_with_reminders)
      visit edit_appointment_url(a)
      find("#reminders li input[type=text]").set(100)
      expect{click_button "Submit"}.to change{a.reminders.first.minutes_before}.to(100)
    end

    it "can delete reminders" do
      a = create(:appointment_with_reminders)
      visit edit_appointment_url(a)
      within("#reminders li") { check }
      expect{click_button "Submit"}.to change{a.reminders.count}.from(1).to(0)
    end
  end
end
