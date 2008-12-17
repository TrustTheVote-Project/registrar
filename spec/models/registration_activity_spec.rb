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
    registration = RegistrationActivity.create!({
      :registration => @registration,
      :message => "value for message",
      :clerk => users(:quentin)
    })
    registration.clerk.should == users(:quentin)
  end
end
