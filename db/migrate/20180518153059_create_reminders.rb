class CreateReminders < ActiveRecord::Migration[5.2]
  def change
    create_table :reminders do |t|
      t.references :appointment, foreign_key: true
      t.integer :minutes_before

      t.timestamps
    end
  end
end
