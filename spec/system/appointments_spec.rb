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
        expect(page).to have_content appointment.title
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
      expect(page).to have_content("A new appointment")
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
      expect{click_button "Submit"}.not_to change{Appointment.count}
      expect(appointment.reload.title).to eql "some new title"
      expect(current_url).to end_with("/appointments")
    end
  end
end
