class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table "users" do |t|
      t.string :login
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :crypted_password
      t.string :salt
      t.string :remember_token
      t.datetime :remember_token_expires_at

      t.timestamps
    end
    add_index :users, :login, :unique => true
  end

  def self.down
    drop_table "users"
  end
end
