class RegistrationActivity < ActiveRecord::Base
  belongs_to :registration
  belongs_to :clerk, :class_name => 'User'
  validates_presence_of :message
  validates_presence_of :registration
end
