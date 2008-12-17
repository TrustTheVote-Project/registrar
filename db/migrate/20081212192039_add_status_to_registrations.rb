class AddStatusToRegistrations < ActiveRecord::Migration
  def self.up
    add_column :registrations, :status, :string
  end

  def self.down
    remove_column :registrations, :status
  end
end
