RSpec.describe "Appointments" do
  it "dummy case" do
    visit "/appointments"
    expect(page).to have_content "Appointments"
  end
end
