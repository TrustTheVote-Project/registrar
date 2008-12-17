require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe RegistrationActivitiesController do

  before do
    @registration = Registration.create(valid_registration_attributes)
    @activity1 = @registration.activities.create(:message => 'Registration was created')
    @activity2 = @registration.activities.create(:message => 'Registration was deleted')

    other_registration = Registration.create!(valid_registration_attributes)
    @activity3 = other_registration.activities.create(:message => 'Registration was created')
  end

  describe 'registration specified' do

    it 'should resolve the registration and find its activities' do
      get :index, :registration_id => @registration.id
      assigns[:activities].should == [@activity1, @activity2]
    end

    it 'should render the citizen view' do
      get :index, :registration_id => @registration.id
      response.should render_template('registration_activities/citizen.html.erb')
    end
  end

  describe 'registration not specified' do
    it 'should find all activities' do
      get :index
      assigns[:activities].should include(@activity1, @activity2, @activity3)
      response.should render_template('registration_activities/supervisor.html.erb')
    end
  end


end
