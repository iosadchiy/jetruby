class Appointment < ApplicationRecord
  enum state: [:pending, :confirmed, :canceled]
end
