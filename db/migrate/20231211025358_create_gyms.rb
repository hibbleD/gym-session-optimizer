class CreateGyms < ActiveRecord::Migration[7.0]
  def change
    create_table :gyms do |t|
      t.string :name
      t.string :location
      t.string :google_place_id

      t.timestamps
    end
  end
end
