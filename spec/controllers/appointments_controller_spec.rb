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

    describe "#create" do
      it "creates an appointment" do
        expect {
          post :create, params: {
            appointment: {title: "A1", starts_at: Time.current.to_s(:db)}
          }
        }.to change{Appointment.count}.by 1
        expect(Appointment.last).to be_confirmed
      end
    end

    describe "#confirm and #cancel" do
      def change_and_check_state(action, from_state, to_state)
        appointment = create :appointment, state: from_state, starts_at: 1.minute.since
        post action, params: {id: appointment.id}
        expect(response).to redirect_to :appointments
        expect(appointment.reload.state).to eql to_state.to_s
      end

      it "can confirm the appointment" do
        change_and_check_state(:confirm, :pending, :confirmed)
      end

      it "can cancel the appointment" do
        change_and_check_state(:cancel, :confirmed, :canceled)
      end
    end
  end
end
