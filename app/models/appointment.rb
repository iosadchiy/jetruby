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
#  user_id    :bigint(8)
#
# Indexes
#
#  index_appointments_on_starts_at            (starts_at)
#  index_appointments_on_state_and_starts_at  (state,starts_at)
#  index_appointments_on_user_id              (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

class Appointment < ApplicationRecord
  DURATION = 1.hour
  enum state: [:pending, :confirmed, :canceled]
  scope :upcoming, ->(t) { where("starts_at > ?", t) }
  scope :upcoming_confirmed, ->(t) { upcoming(t).confirmed }
  scope :past, ->(t) { where("starts_at <= ?", t) }
  scope :past_confirmed, ->(t) { past(t).confirmed }
  default_scope { order(starts_at: :desc) }

  belongs_to :user
  has_many :reminders
  validates_associated :reminders
  accepts_nested_attributes_for :reminders, reject_if: :all_blank, allow_destroy: true

  before_save :reschedule_reminders!

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

  def reschedule_reminders!
    if upcoming_confirmed?
      reminders.all.each do |r|
        if r.remind_at > Time.current
          r.pending!
        else
          r.sent!
        end
      end
    end
  end

  def remind_email
    user.email
  end

  def build_nested
    reminders.build if reminders.empty?
  end

  def needs_confirmation?
    pending? && upcoming?
  end

  def upcoming?
    starts_at > Time.current
  end

  def upcoming_confirmed?
    upcoming? && confirmed?
  end

  def clashes
    return [] if starts_at.nil?
    # Does not clash if A.starts_at >= B.ends_at or A.ends_at <= B.starts_at
    # By DeMorgan, it clashes if A.starts_at < B.ends_at and A.ends_at > B.starts_at
    # And we don't know A.ends_at: A.ends_at > B.starts_at <=> A.starts_at > B.starts_at-duration
    user.appointments.confirmed.where.not(id: id)
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
