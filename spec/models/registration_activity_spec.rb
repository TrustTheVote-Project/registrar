require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe RegistrationActivity do

  before do
    @registration = Registration.create!(valid_registration_attributes)
  end

  it "should create a new instance given minimal valid attributes" do
    RegistrationActivity.create!({
      :registration => @registration,
      :message => "value for message"
    })
  end

  it "should require a message" do
    invalid = RegistrationActivity.new
    invalid.should_not be_valid
    invalid.errors.on(:message).should_not be_nil
  end

  it "should require a registration" do
    invalid = RegistrationActivity.new
    invalid.should_not be_valid
    invalid.errors.on(:registration).should_not be_nil
  end

  it "should know its clerk if given" do
    activity = RegistrationActivity.create!({
      :registration => @registration,
      :message => "value for message",
      :clerk => users(:quentin)
    })
    activity.clerk.should == users(:quentin)
  end
  
  describe "#reason_and_comment" do
    it "divides reason from comment splitting on ' - '" do
      activity = RegistrationActivity.create!({
        :registration => @registration,
        :message => "value for message",
        :comment => 'reason - and the comment'
      })
      r, c = activity.reason_and_comment
      r.should == 'reason'
      c.should == 'and the comment'
    end
    
    it "should not fail when comment nil" do
      activity = RegistrationActivity.create!({
        :registration => @registration,
        :message => "value for message"
      })
      r, c = activity.reason_and_comment
      r.should be_blank
      c.should be_blank
    end
  end
end
