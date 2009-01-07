class Registration < ActiveRecord::Base
  has_many :activities, :class_name => 'RegistrationActivity', :order => 'created_at desc'

  acts_as_state_machine :initial => :draft, :column => 'status'

  attr_accessor :acting_clerk
  attr_accessor :activity_comment

  state :draft
  state :submitted, :enter => Proc.new {|r| r.add_activity('Registration form validated.
    Next Step: Your signed original voter registration form must be received at the Adams County Board of Elections.', false)}
  state :received, :enter => Proc.new {|r| r.add_activity('Registration form received.
    Next Step: A registration clerk should begin the processing of your form shortly.')}
  state :rejected, :enter => Proc.new {|r| r.add_activity('Registration form rejected due to inadequate or missing signature.
    Next Step: Your request cannot be processed because it did not contain a valid signature. Please print and
    properly sign your registration form and resubmit it.')}
  state :approved, :enter => Proc.new {|r| r.add_activity('Registration form validated, awaiting DMV approval.
    Next Step: Your form and signature have been accepted. Your voter registration request is pending
    completion of a cross-check with the Department of Motor Vehicles.')}

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
  validates_presence_of :party
  validates_presence_of :id_number

  def add_activity(message, set_clerk = true)
    activities.create(
        :message => message,
        :clerk => set_clerk ? acting_clerk : nil,
        :location => ['Adams County Board of Elections, 532 Tower Road', 'Adams County Records Offices, 89 Courthouse Way', 'Office of the Adams County Recorder, 731 Madison St.'].rand,
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

  def full_address
    "%s&nbsp;&nbsp;%s, %s&nbsp;&nbsp;%s" % [address, city, state, zip]
  end

  def city_state_zip
    "%s, %s&nbsp;&nbsp;%s" % [city, state, zip]
  end
end