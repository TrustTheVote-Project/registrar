class RegistrationActivitiesController < ApplicationController

  def index
    registration_id = params[:registration_id]
    if registration_id
      @registration = Registration.find(registration_id)
      @activities = @registration.activities
    else
      @activities = RegistrationActivity.find(:all, :order => 'created_at desc')
    end
    if @registration
      render :template => '/registration_activities/citizen', :layout => 'citizen'
    else
      render :template => '/registration_activities/supervisor', :layout => 'clerk'
    end
  end

end
