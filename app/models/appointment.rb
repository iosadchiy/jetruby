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

class Appointment < ApplicationRecord
  enum state: [:pending, :confirmed, :canceled]
end
