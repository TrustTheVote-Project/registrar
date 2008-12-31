class RemoveDeclineToStateIdNumber < ActiveRecord::Migration
  def self.up
    remove_column :registrations, :decline_to_state_id_number
  end

  def self.down
    add_column :registrations, :decline_to_state_id_number, :boolean
  end
end
