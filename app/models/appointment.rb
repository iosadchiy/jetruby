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

class Appointment < ApplicationRecord
  DURATION = 1.hour
  enum state: [:pending, :confirmed, :canceled]
  scope :upcoming, ->(t) { where("starts_at > ?", t) }
  scope :upcoming_confirmed, ->(t) { upcoming(t).confirmed }
  scope :past, ->(t) { where("starts_at <= ?", t) }
  default_scope { order(starts_at: :desc) }

  def self.relevant_pending(t)
    pending.upcoming(t)
  end

  def self.canceled_or_obsolete(t)
    canceled.or(pending.past(t))
  end

  validates :title, presence: true
  validates :starts_at, presence: true
  validate do
    unless clashes.empty?
      errors.add(:starts_at, I18n.t("appointments.errors.messages.clashes"))
    end
  end

  def clashes
    return [] if starts_at.nil?
    # Does not clash if A.starts_at >= B.ends_at or A.ends_at <= B.starts_at
    # By DeMorgan, it clashes if A.starts_at < B.ends_at and A.ends_at > B.starts_at
    # And we don't know A.ends_at: A.ends_at > B.starts_at <=> A.starts_at > B.starts_at-duration
    self.class.confirmed.where.not(id: id)
      .where("starts_at < ? AND starts_at > ?", ends_at, starts_at-DURATION)
  end

  def ends_at
    starts_at + duration
  end

  def duration
    DURATION
  end

  def to_s
    from = starts_at.to_s(:short)
    to = ends_at.to_s(:short)
    "#{title}: from #{from} to #{to}"
  end
end
