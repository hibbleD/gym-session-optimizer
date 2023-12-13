class CreateBusyTimes < ActiveRecord::Migration[7.0]
  def change
    create_table :busy_times do |t|
      t.string :day_of_week
      t.integer :hour
      t.string :busyness_level
      t.references :gym, null: false, foreign_key: true

      t.timestamps
    end
  end
end
