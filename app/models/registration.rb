class Registration < ActiveRecord::Base
  has_many :activities, :class_name => 'RegistrationActivity', :order => 'created_at desc'

  acts_as_state_machine :initial => :draft, :column => 'status'

  attr_accessor :acting_clerk
  attr_accessor :activity_comment

  state :draft
  state :submitted, :enter => Proc.new {|r| r.add_activity('Registration submitted', false)}
  state :received, :enter => Proc.new {|r| r.add_activity('Registration received')}
  state :rejected, :enter => Proc.new {|r| r.add_activity('Registration rejected')}
  state :approved, :enter => Proc.new {|r| r.add_activity('Registration approved')}

  event :submit do
    transitions :to => :submitted, :from => :draft
  end

  event :receive do
    transitions :to => :received, :from => :submitted
  end

  event :reject do
    transitions :to => :rejected, :from => :received
  end

  event :approve do
    transitions :to => :approved, :from => :received
  end

  validates_presence_of :first_name
  validates_presence_of :address
  validates_presence_of :city
  validates_presence_of :state
  validates_presence_of :zip
  validates_presence_of :date_of_birth

  def add_activity(message, set_clerk = true)
    activities.create(
        :message => message,
        :clerk => set_clerk ? acting_clerk : nil,
        :location => ['District 7 branch', 'Jefferson Avenue district branch', 'Madison Street depot'].rand,
        :ip_address => "#{[123, 234, 456].rand}.#{[987, 876, 654].rand}.#{[4, 5, 6].rand}.#{[6, 7, 8].rand}",
        :comment => activity_comment
    )

    self.acting_clerk = nil
    self.activity_comment = nil
  end

  def under_edit?
    status.nil? || draft?
  end

  def name
    first_name + (last_name ? " #{last_name}" : '')
  end

  def abbreviated_name
    first_name + (last_name ? " #{last_name.first}" : '')
  end

end