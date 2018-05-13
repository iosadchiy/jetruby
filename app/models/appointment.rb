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

class Appointment < ApplicationRecord
  enum state: [:pending, :confirmed, :canceled]

  def ends_at
    starts_at + duration
  end

  def duration
    1.hour
  end

  def to_s
    title
  end
end
