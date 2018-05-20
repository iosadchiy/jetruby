# == Schema Information
#
# Table name: api_stats
#
#  id         :bigint(8)        not null, primary key
#  create_avg :float
#  create_n   :bigint(8)
#  index_avg  :float
#  index_n    :bigint(8)
#  user_id    :bigint(8)
#
# Indexes
#
#  index_api_stats_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

require 'rails_helper'

RSpec.describe ApiStat, type: :model do
  let(:a) { create(:user).api_stat }

  describe '#record' do
    it "records stats" do
      a.record!("index", 1)
      a.record!("index", 2)
      expect(a.index_avg).to eql 1.5
      expect(a.index_n).to eql 2
    end

    it "sets default values" do
      expect(a.index_n).to eql 0
    end

    it "does not accept unknown request types" do
      expect{a.record!("bla", 1)}.to raise_error(RuntimeError)
    end
  end

  describe 'self.process_request' do
    it "finds the ApiStat and records" do
      auth_header = "Token token=#{a.user.api_key}"
      expect{ApiStat.process_request(auth_header, "create", 8.5)}
        .to change{a.user.api_stat.reload.create_avg}.from(0.0).to(8.5)
    end
  end
end
