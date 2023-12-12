class ChangePreferredTimesToTime < ActiveRecord::Migration[6.0]
  def change
    change_column :users, :preferred_start_time, :time
    change_column :users, :preferred_end_time, :time
  end
end
