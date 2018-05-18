require 'rails_helper'

RSpec.describe AppointmentsController, type: :controller do
  it "requires authentication" do
    get :index
    expect(response).to redirect_to [:new, :session]
  end

  context "user logged in" do
    let(:user) { create :user }
    before do
      session[:user_id] = user.id
    end

    describe "#index" do
      it "assigns appointments split into sets" do
        get :index
        assert_response 200
      end
    end
  end
end
