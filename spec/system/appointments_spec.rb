RSpec.describe "Appointments", js: true do
  it "dummy case" do
    visit "/appointments"
    expect(page).to have_content "Appointments"
  end
end
