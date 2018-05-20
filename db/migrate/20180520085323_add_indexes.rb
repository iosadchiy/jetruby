class AddIndexes < ActiveRecord::Migration[5.2]
  def change
    add_index :reminders, [:appointment_id, :state]
    add_index :appointments, [:state, :starts_at]
  end
end
