# == Schema Information
#
# Table name: appointments
#
#  id         :bigint(8)        not null, primary key
#  ends_at    :datetime
#  starts_at  :datetime
#  state      :integer
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Appointment, type: :model do
end
