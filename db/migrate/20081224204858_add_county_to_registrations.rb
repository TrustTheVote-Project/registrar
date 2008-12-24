class AddCountyToRegistrations < ActiveRecord::Migration
  def self.up
      add_column :registrations, :county, :string
  end

  def self.down
      remove_column :registrations, :id_number
  end
end
