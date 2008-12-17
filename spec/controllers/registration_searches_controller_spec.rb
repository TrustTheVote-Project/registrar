require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe RegistrationSearchesController do

  describe '#new' do

    it 'should require login' do
      get :new
      response.should redirect_to(new_session_path)
    end

    it 'should render the search page' do
      login_as(:quentin)
      get :new
      response.should render_template('new')
    end
  end

  describe '#create' do

    it 'should require login' do
      post :create
      response.should redirect_to(new_session_path)
    end

    it 'should find a received registration' do
      login_as(:quentin)
      registration = Registration.create!(valid_registration_attributes)
      registration.submit!; registration.receive!

      post :create, :registration_id => registration.id
      response.should redirect_to(registration_path(registration))
    end

    it 'should not find a registration that is not received' do
      login_as(:quentin)
      registration = Registration.create!(valid_registration_attributes)
      registration.submit!; registration.receive!; registration.reject!

      post :create, :registration_id => registration.id
      response.should redirect_to(new_registration_search_path)
    end

    it 'should not find a non-existant registration' do
      login_as(:quentin)
      post :create, :registration_id => 10000000
      response.should redirect_to(new_registration_search_path)
    end
  end

end
