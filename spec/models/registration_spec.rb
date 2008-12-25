require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Registration do

  describe 'states' do

    it "should know its initial state" do
      Registration.initial_state.should == :draft
    end

    it "should know its valid states" do
      Registration.states.should include(:draft, :submitted, :received, :rejected, :approved)
      Registration.states.size.should == 5
    end

    it "should know its state column" do
      Registration.state_column.should == 'status'
    end

    it "should start in draft" do
      Registration.create!(valid_registration_attributes).current_state.should == :draft
    end

  end

  describe 'state transitions' do
    before do
      @registration = Registration.create!(valid_registration_attributes)
    end

    it "should create an activity when moving from draft to submitted" do
      @registration.activities.should be_empty
      @registration.submit!
      @registration.activities.size.should == 1
    end

    it "should create an activity when moving from submitted to received" do
      @registration.submit!
      @registration.receive!
      @registration.activities.size.should == 2
    end

    it "should create an activity when moving from received to rejected" do
      @registration.submit!
      @registration.receive!
      @registration.reject!
      @registration.activities.size.should == 3
    end

    it "should create an activity when moving from received to approved" do
      @registration.submit!
      @registration.receive!
      @registration.approve!
      @registration.activities.size.should == 3
      @registration.reload.activities.size.should == 3
      @registration.reload.current_state.should == :approved
    end

    it 'should not set the clerk when an acting clerk is specified when transitioning to submitted' do
      @registration.acting_clerk = users(:quentin)
      @registration.submit!
      @registration.activities.first.clerk.should be_nil
    end

    it 'should set the clerk when an acting clerk is specified when transitioning to received' do
      @registration.submit!
      @registration.activities.clear
      @registration.acting_clerk = users(:quentin)
      @registration.receive!
      @registration.acting_clerk.should be_nil
      @registration.activities.first.clerk.should == users(:quentin)
    end

    it 'should set the clerk when an acting clerk is specified when transitioning to approved' do
      @registration.submit!
      @registration.receive!
      @registration.activities.clear
      @registration.acting_clerk = users(:quentin)
      @registration.approve!
      @registration.acting_clerk.should be_nil
      @registration.activities.first.clerk.should == users(:quentin)
    end

    it 'should set the clerk when an acting clerk is specified when transitioning to rejected' do
      @registration.submit!
      @registration.receive!
      @registration.activities.clear
      @registration.acting_clerk = users(:quentin)
      @registration.reject!
      @registration.acting_clerk.should be_nil
      @registration.activities.first.clerk.should == users(:quentin)
    end

    it 'should set the comment when a activity comment is specified' do
      comment = 'I hope this works!'
      @registration.activity_comment = comment
      @registration.submit!
      @registration.activity_comment.should be_nil
      @registration.activities.first.comment.should == comment
    end

  end

  describe 'under_edit' do
    it 'should be under_edit when new or draft' do
      [nil, :draft].each do |state|
        registration = Registration.new
        registration.status = state
        registration.should be_under_edit
      end
    end

    it 'should not be under_edit when new or draft' do
      (Registration.states - [:draft]).each do |state|
        registration = Registration.new
        registration.status = state
        registration.should_not be_under_edit
      end
    end
  end

  describe 'name' do

    before do
      @with_last_name = Registration.new(:first_name => 'John', :last_name => 'Smith')
      @without_last_name = Registration.new(:first_name => 'John')
    end

    it 'should know its name' do
      @with_last_name.name.should == 'John Smith'
      @without_last_name.name.should == 'John'
    end

    it 'should know its abbreviated name' do
      @with_last_name.abbreviated_name.should == 'John S'
      @without_last_name.abbreviated_name.should == 'John'
    end
  end

  describe 'validations' do

    it 'should require the correct fields' do
      [:first_name, :address, :city, :state, :zip, :date_of_birth, :party].each do |field|
        invalid = Registration.new
        invalid.should_not be_valid
        invalid.errors.on(field).should_not be_nil
      end
    end

    it 'should require an ID number if not declining to state ID number' do
      invalid = Registration.new
      invalid.should_not be_decline_to_state_id_number

      invalid.should_not be_valid
      invalid.errors.on(:id_number).should_not be_nil
    end

    it 'should not require an ID number if declining to state ID number' do
      invalid = Registration.new
      invalid.decline_to_state_id_number = true

      invalid.valid?
      invalid.errors.on(:id_number).should be_nil
    end

    it 'should not allow an ID number if declining to state ID number' do
      invalid = Registration.new
      invalid.decline_to_state_id_number = true
      invalid.id_number = '1234'

      invalid.should_not be_valid
      invalid.errors.on(:id_number).should_not be_nil
    end
  end

end