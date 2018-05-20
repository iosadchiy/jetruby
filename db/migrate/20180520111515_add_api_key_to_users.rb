class AddApiKeyToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :api_key, :string
    add_index :users, :api_key, unique: true
    add_index :users, [:uid, :provider], unique: true
  end
end
