class CreateRegistrations < ActiveRecord::Migration
  def self.up
    create_table :registrations do |t|
      t.string :salutation
      t.string :first_name
      t.string :middle_name
      t.string :last_name
      t.string :address
      t.string :city
      t.string :state
      t.string :zip
      t.date :date_of_birth
      t.string :phone
      t.string :party
      t.string :race

      t.timestamps
    end
  end

  def self.down
    drop_table :registrations
  end
end
