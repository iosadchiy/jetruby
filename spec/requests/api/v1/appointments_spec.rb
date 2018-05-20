RSpec.describe "Appointments API" do
  include Rack::Test::Methods

  # def sign_in(user=nil)
  #   user ||= create(:user)
  #   request.headers["Authorization"] = "Token token=#{user.token}"
  # end

  def body
    JSON.parse last_response.body
  end

  def body_ids
    body.map{|a| a['id']}
  end

  def body_struct
    OpenStruct.new(body)
  end

  it "requires authentication" do
    get '/api/v1/appointments'
    expect(last_response).to be_unauthorized
  end

  it "requires valid credentials" do
    get '/api/v1/appointments', headers: {Authorization: "Token token=fake"}
    expect(last_response).to be_unauthorized
  end

  context "when authenticated" do
    let!(:user) { create(:user) }

    before do
      header 'Authorization', "Token token=" + user.api_key
    end

    it "works" do
      get '/api/v1/appointments'
      expect(last_response).to be_ok
      expect(body).to eql []
    end

    describe "#index" do
      context "when there are appointments" do
        let!(:users_appointments) { create_list :appointment, 2, user: user }
        let!(:others_appointments) { create_list :appointment, 2, user: create(:user) }

        it "shows only user's appointments" do
          get '/api/v1/appointments'
          expect(body_ids).to match_array users_appointments.pluck(:id)
        end

        it "can filter by date" do
          a = create(:appointment, user: user, starts_at: "2018-05-01 00:00 +0300")
          b = create(:appointment, user: user, starts_at: "2018-05-01 23:00 +0300")
          c = create(:appointment, user: user, starts_at: "2018-04-30 23:00 +0300")
          get '/api/v1/appointments', {date: "2018-05-01"}
          expect(body_ids).to match_array [a.id, b.id]
        end
      end
    end

    describe "#create" do
      it "creates an appointment" do
        a = build(:appointment, starts_at: "2018-05-01 00:00 +0300")
        expect {
          post 'api/v1/appointments', {appointment: {title: a.title, starts_at: a.starts_at}}
        }.to change{user.appointments.count}.by(1)
        expect(last_response).to be_created
        expect(body_struct.title).to eql a.title
        expect(Time.parse body_struct.starts_at).to eql a.starts_at
        expect(body_struct.state).to eql "pending"
      end

      it "cannot create invalid appointment" do
        expect {
          post 'api/v1/appointments', {appointment: {title: ""}}
        }.not_to change{user.appointments.count}
        expect(last_response).to be_unprocessable
      end
    end
  end
end
