require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  let(:auth) { build_auth }
  let!(:user) { create :user, uid: auth.uid, provider: auth.provider }

  describe "GET #create" do
    it "creates a user session" do
      controller.request.env["omniauth.auth"] = auth
      get :create
      expect(response).to redirect_to :root
      expect(session['user_id']).to eql user.id
    end
  end

  describe "GET #destroy" do
    it "closes the user session" do
      session['user_id'] = 1
      get :destroy
      expect(session['user_id']).to be_nil
    end
  end

end
