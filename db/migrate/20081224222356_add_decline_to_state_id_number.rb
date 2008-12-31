class AddDeclineToStateIdNumber < ActiveRecord::Migration
  def self.up
    add_column :registrations, :decline_to_state_id_number, :boolean
  end

  def self.down
    remove_column :registrations, :decline_to_state_id_number
  end
end
