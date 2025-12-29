class CreateRaces < ActiveRecord::Migration[8.1]
  def change
    create_table :races do |t|
      t.string :name, limit: 255, null: false
      t.datetime :start_time, null: false
      t.text :location_description, null: false
      t.string :location_address
      t.integer :city, null: false
      t.string :registration_url
      t.text :registration_info
      t.boolean :day_of_race_registration, default: false, null: false
      t.decimal :cost, precision: 6, scale: 2
      t.text :notes
      t.integer :status, default: 0, null: false
      t.string :organizer_name
      t.text :organizer_contact
      t.datetime :published_at

      t.timestamps
    end

    add_index :races, :status
    add_index :races, :city
  end
end
