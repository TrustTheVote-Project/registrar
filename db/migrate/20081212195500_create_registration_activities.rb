class CreateRegistrationActivities < ActiveRecord::Migration
  def self.up
    create_table :registration_activities do |t|
      t.integer :registration_id
      t.string :message

      t.timestamps
    end
  end

  def self.down
    drop_table :registration_activities
  end
end
