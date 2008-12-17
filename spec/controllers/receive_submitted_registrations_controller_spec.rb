require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ReceiveSubmittedRegistrationsController do

  before do
    @draft = Registration.create!(valid_registration_attributes)
    @submitted1 = Registration.create!(valid_registration_attributes)
    @submitted1.submit!
    @submitted2 = Registration.create!(valid_registration_attributes)
    @submitted2.submit!
    @received = Registration.create!(valid_registration_attributes)
    @received.submit!; @received.receive!
    @approved = Registration.create!(valid_registration_attributes)
    @approved.submit!; @approved.receive!; @approved.approve!
    @rejected = Registration.create!(valid_registration_attributes)
    @rejected.submit!; @rejected.receive!; @rejected.reject!
  end

  it 'should require login' do
    put :update
    response.should redirect_to(new_session_path)
  end

  it 'should transition all the draft registrations to submitted' do
    login_as(:quentin)
    put :update
    @draft.reload.should be_draft
    @submitted1.reload.should be_received
    @submitted2.reload.should be_received
    @received.reload.should be_received
    @approved.reload.should be_approved
    @rejected.reload.should be_rejected
  end

  it 'should set logged-clerk on created activities' do
    @submitted1.activities.clear
    login_as(:quentin)
    put :update
    @submitted1.reload.activities.first.clerk.should == users(:quentin)
  end

  it 'should redirect to clerk landing' do
    login_as(:quentin)
    put :update
    response.should redirect_to(clerk_landing_path)
  end

end
