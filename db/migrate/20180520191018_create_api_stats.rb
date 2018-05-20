class CreateApiStats < ActiveRecord::Migration[5.2]
  def change
    create_table :api_stats do |t|
      t.references :user, foreign_key: true
      t.bigint :index_n
      t.float :index_avg
      t.bigint :create_n
      t.float :create_avg
    end
  end
end
