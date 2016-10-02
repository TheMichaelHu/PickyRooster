class CreateAlerts < ActiveRecord::Migration
  def change
    create_table :alerts do |t|
      t.integer :from_id, null: false
      t.integer :to_id, null: false
      t.string :url, null: false
      t.boolean :played, default: false
      t.timestamps null: false
    end
  end
end
