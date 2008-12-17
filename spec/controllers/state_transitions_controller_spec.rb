require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe StateTransitionsController do

  before do
    @registration = Registration.create!(valid_registration_attributes)
    @registration.submit!
    @registration.activities.clear
  end

  describe 'transitioning the registration' do
    it 'should transition the registration in the absence of a clerk' do
      put :update, :registration_id => @registration.id, :transition => 'receive'
      @registration.reload.current_state.should == :received
      @registration.activities.size.should == 1
      @registration.activities.first.clerk.should be_nil
    end

    it 'should transition the registration in the presence of a clerk' do
      login_as(:quentin)
      put :update, :registration_id => @registration.id, :transition => 'receive'
      @registration.reload.current_state.should == :received
      @registration.activities.size.should == 1
      @registration.activities.first.clerk.should == users(:quentin)
    end

    it 'should set the activity comment field to the given comment' do
      put :update, :registration_id => @registration.id, :transition => 'receive', :comment => 'I picked it up!'
      @registration.reload.activities.first.comment.should == 'I picked it up!'
    end
  end

  it 'should redirect to registration show' do
    put :update, :registration_id => @registration.id, :transition => 'receive'
    response.should redirect_to(registration_path(@registration))
  end

end
