class AddStateToReminders < ActiveRecord::Migration[5.2]
  def change
    add_column :reminders, :state, :integer, default: 0
  end
end
