RSpec.describe "Appointments" do
  before do
    sign_in
  end

  describe '#index' do
    it "shows some stats" do
      user = create(:user)
      user.api_stat.record!("index", 5)
      user.api_stat.record!("create", 10)
      visit "/stats"
      expect(page).to have_content(user.email, count: 1)
      expect(page).to have_content(5, count: 1)
      expect(page).to have_content(10, count: 1)
    end
  end
end
