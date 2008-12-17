class AddClerkIdCommentLocationAndIpAddressToRegistrationActivities < ActiveRecord::Migration
  def self.up
    add_column :registration_activities, :clerk_id, :integer
    add_column :registration_activities, :comment, :string
    add_column :registration_activities, :location, :string
    add_column :registration_activities, :ip_address, :string
  end

  def self.down
    remove_column :registration_activities, :clerk_id
    remove_column :registration_activities, :comment
    remove_column :registration_activities, :location
    remove_column :registration_activities, :ip_address
  end
end
