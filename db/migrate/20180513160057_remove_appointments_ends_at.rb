class RemoveAppointmentsEndsAt < ActiveRecord::Migration[5.2]
  def change
    remove_column :appointments, :ends_at, :datetime
  end
end
