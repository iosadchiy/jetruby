class CreateAppointments < ActiveRecord::Migration[5.2]
  def change
    create_table :appointments do |t|
      t.integer :state
      t.datetime :starts_at
      t.datetime :ends_at
      t.string :title

      t.timestamps
    end
  end
end
