class AddStatusAndNextStepToRegistrationActivities < ActiveRecord::Migration
  def self.up
    add_column :registration_activities, :status, :string
    add_column :registration_activities, :next_step, :string
  end

  def self.down
    remove_column :registration_activities, :next_step
    remove_column :registration_activities, :status
  end
end
