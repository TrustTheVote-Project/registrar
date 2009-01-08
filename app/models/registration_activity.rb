class RegistrationActivity < ActiveRecord::Base
  belongs_to :registration
  belongs_to :clerk, :class_name => 'User'
  validates_presence_of :message
  validates_presence_of :registration
  
  def kind
    case self.message
      when /must be received/
        :submitted
      when /Registration form received/
        :received
      when /Registration form rejected/
        :rejected
      when /Registration form validated/
        :validated
      else
        :unknown
    end
  end
  
  def reason_and_comment
    (self.comment || "").split(' - ', 2)
  end
end
