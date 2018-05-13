class IndexAppointmentsStartsAt < ActiveRecord::Migration[5.2]
  def change
    add_index :appointments, :starts_at
  end
end
