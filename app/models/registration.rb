class Registration < ActiveRecord::Base
  has_many :activities, :class_name => 'RegistrationActivity', :order => 'created_at desc'

  acts_as_state_machine :initial => :draft, :column => 'status'

  attr_accessor :acting_clerk
  attr_accessor :activity_comment

  state :draft
  state :submitted, :enter => Proc.new {|r| r.add_activity('Registration form has not yet arrived in the mail.
    Next Step: After your signed original voter registration form is received at the Adams County Board of Elections,
    the processing of your voter registration request will begin.', false)}
  state :received, :enter => Proc.new {|r| r.add_activity('Registration form received from the USPS.
    Next Step: A registration clerk should begin the processing of your form shortly.')}
  state :rejected, :enter => Proc.new {|r| r.add_activity('Registration form rejected due to inadequate or missing signature.
    Next Step: Your request cannot be processed further because it did not contain a valid signature. Please print and
    properly sign your registration form and resubmit it to the Adams Country Board of Elections.')}
  state :approved, :enter => Proc.new {|r| r.add_activity('Registration form validated, awaiting approval.
    Next Step: Your request form and signature have been accepted. Your voter registration request is pending
    completion of a cross-check of your information with the Department of Motor Vehicles.')}

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
  validates_presence_of :id_number, :if => Proc.new {|r| !r.decline_to_state_id_number? }
  validates_format_of :id_number, :with => /^$/, :if => Proc.new {|r| r.decline_to_state_id_number?}

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

end