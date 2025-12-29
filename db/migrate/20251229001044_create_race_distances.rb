class CreateRaceDistances < ActiveRecord::Migration[8.1]
  def change
    create_table :race_distances do |t|
      t.references :race, null: false, foreign_key: { on_delete: :cascade }
      t.decimal :distance_value, precision: 4, scale: 1, null: false
      t.integer :distance_unit, null: false

      t.timestamps
    end
    # Note: t.references already creates an index on race_id
  end
end
