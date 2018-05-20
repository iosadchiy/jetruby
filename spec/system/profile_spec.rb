RSpec.describe "Profile" do
  let(:user) { create(:user) }
  before do
    sign_in(user)
  end

  it "shows my api key" do
    visit "/profile"
    expect(page).to have_content(user.api_key, count: 1)
  end
end
