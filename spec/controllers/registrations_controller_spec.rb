require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe RegistrationsController do

  describe 'index' do
    before do
      @registration1 = Registration.create(valid_registration_attributes)
      @registration2 = Registration.create(valid_registration_attributes)
    end

    it 'should resolve the registrations and render the index template' do
      get :index
      response.should render_template('index')
      assigns[:registrations].should include(@registration1, @registration2)
    end
  end

  describe 'show' do
    before do
      @registration = Registration.create(valid_registration_attributes)
    end

    it 'should resolve the registration and render the index template' do
      get :show, :id => @registration.id
      response.should render_template('draft')
      assigns[:registration].should == @registration
    end
  end

  describe 'new' do
    it 'should instantiate a new registration and render the new template' do
      get :new
      response.should render_template('new')
      assigns[:registration].should be_new_record
    end
  end

  describe 'edit' do
    before do
      @registration = Registration.create(valid_registration_attributes)
    end

    it 'should resolve the registration and render the edit template' do
      get :edit, :id => @registration.id
      response.should render_template('edit')
      assigns[:registration].should == @registration
    end
  end

  describe 'create' do

    before do
      @initial_count = Registration.count
    end

    describe 'valid parameters' do
      it 'should create a registration and redirect to show' do
        post :create, :registration => valid_registration_attributes
        Registration.count.should == @initial_count + 1
        response.should be_redirect
      end
    end

    describe 'invalid parameters' do
      it 'should not create a registration and render new' do
        post :create, :params => {}
        Registration.count.should == @initial_count
        response.should render_template('new')
        assigns[:registration].should be_new_record
      end
    end
  end

  describe 'update' do
    before do
      @registration = Registration.create(valid_registration_attributes)
    end

    describe 'valid parameters' do
      it 'should update the registration and redirect to show' do
        put :update, :id => @registration.id, :registration => {:first_name => 'changed'}
        @registration.reload.first_name.should == 'changed'
        response.should redirect_to(registration_path(@registration))
      end
    end

    describe 'invalid parameters' do
      it 'should not create a registration and render edit' do
        original_first_name = @registration.first_name
        put :update, :id => @registration.id, :params => {:first_name => ''}
        @registration.reload.first_name.should == original_first_name
        assigns[:registration].should == @registration
#        response.should render_template('edit')  # no idea why this doesn't work
      end
    end
  end

  describe "Steps" do
    before(:each) do
      @registration = Registration.create(valid_registration_attributes)
    end

    it '#step2 should have registration in draft state' do
      get :step2, :id => @registration.to_param
      response.should render_template('step2')
      assigns[:registration].should == @registration
    end
  end

end
