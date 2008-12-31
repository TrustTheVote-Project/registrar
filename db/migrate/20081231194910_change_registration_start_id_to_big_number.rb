class ChangeRegistrationStartIdToBigNumber < ActiveRecord::Migration
  def self.up
    execute "ALTER TABLE registrations AUTO_INCREMENT = 203802000;"
  end

  def self.down
  end
end
