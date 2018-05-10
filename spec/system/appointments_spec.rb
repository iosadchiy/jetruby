RSpec.describe "Appointments" do
  it "dummy case" do
    visit "/appointments"
    expect(page).to have_content "Appointments", "No results"

    Appointment.create(title: "Appointment 1")
    visit "/appointments"
    expect(page).to have_content "Appointment 1"
  end
end
