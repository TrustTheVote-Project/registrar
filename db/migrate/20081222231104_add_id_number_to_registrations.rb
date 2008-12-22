class AddIdNumberToRegistrations < ActiveRecord::Migration
  def self.up
    add_column :registrations, :id_number, :string
  end

  def self.down
    remove_column :registrations, :id_number
  end
end
