class RemoveRaceFromRegistrations < ActiveRecord::Migration
  def self.up
    remove_column :registrations, :race
  end

  def self.down
    add_column :registrations, :race, :string
  end
end
