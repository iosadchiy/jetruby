# == Schema Information
#
# Table name: appointments
#
#  id         :bigint(8)        not null, primary key
#  starts_at  :datetime
#  state      :integer
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_appointments_on_starts_at  (starts_at)
#

require 'rails_helper'

RSpec.describe Appointment, type: :model do
  it "factory is valid" do
    expect(build(:appointment)).to be_valid
  end

  it "lasts for 1 hour" do
    a = build(:appointment, starts_at: Time.current)
    expect(a.ends_at - a.starts_at).to eql 1.hour.to_f
  end

  describe "validations" do
    it "does not allow clashes" do
      t = Time.current+1.hour
      create(:appointment, starts_at: t)

      expect(build(:appointment, starts_at: t-59.minutes)).to be_invalid
      expect(build(:appointment, starts_at: t+59.minutes)).to be_invalid
      expect(build(:appointment, starts_at: t-60.minutes)).to be_valid
      expect(build(:appointment, starts_at: t+60.minutes)).to be_valid
    end

    it "requires starts_at to be present and to be a datetime" do
      expect(build(:appointment, starts_at: "")).to be_invalid
      expect(build(:appointment, starts_at: "arstarst")).to be_invalid
      expect(build(:appointment, starts_at: "2018-05-13 20:45")).to be_valid
    end

    it "requires title" do
      expect(build(:appointment, title: "")).to be_invalid
    end
  end

  describe "#clashes" do
    let(:t) { Time.current }
    let!(:a1) { create(:appointment, starts_at: t)}
    let!(:a2) { create(:appointment, starts_at: t+2.hours)}

    it "can fit into 1 hour gap" do
      a = build(:appointment, starts_at: t+1.hour)
      expect(a.clashes).to be_empty
    end

    it "clashes with one of the appointments" do
      a = build(:appointment, starts_at: t+1.hour-1.second)
      expect(a.clashes.ids).to eql [a1.id]
    end

    it "does not clash with itself" do
      expect(a1.clashes).to be_empty
    end
  end

  describe "queries" do
    context "when there're no appointments" do
      it "everything is empty" do
        t = Time.current
        [:upcoming, :upcoming_confirmed, :past, :relevant_pending, :canceled_or_obsolete].each do |method|
          expect(Appointment.send(method, t)).to be_empty
        end
      end
    end

    context "when multiple appointments are present" do
      let!(:t) { Time.current }
      let!(:upcoming) { create :appointment, starts_at: 1.hour.since(t), state: :confirmed }
      let!(:past) { create :appointment, starts_at: t, state: :confirmed }
      let!(:relevant_pending) { create :appointment, starts_at: 2.hours.since(t), state: :pending }
      let!(:future_canceled) { create :appointment, starts_at: 3.hours.since(t), state: :canceled}
      let!(:past_canceled) { create :appointment, starts_at: 1.hour.before(t), state: :canceled}

      def scoped(method, t)
        Appointment.send(method, t).pluck(:id)
      end

      it {
        expect(scoped(:upcoming, t)).to \
          match_array [upcoming.id, relevant_pending.id, future_canceled.id]
      }
      it { expect(scoped(:upcoming_confirmed, t)).to eql [upcoming.id] }
      it { expect(scoped(:past, t)).to match_array [past.id, past_canceled.id] }
      it { expect(scoped(:relevant_pending, t)).to eql [relevant_pending.id] }
      it { expect(scoped(:canceled_or_obsolete, t)).to match_array [future_canceled.id, past_canceled.id] }

      it "should be sorted by starts_at" do
        times = Appointment.all.pluck(:starts_at)
        expect(times).to eql times.sort.reverse
      end
    end
  end
end
