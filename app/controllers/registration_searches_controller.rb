class RegistrationSearchesController < ApplicationController
  layout 'clerk'
  before_filter :login_required

  def new
  end

  def create
    registration_id = params[:registration_id]
    registration = Registration.find_by_id(registration_id) if registration_id
    if registration && registration.received?
      redirect_to(registration_path(registration))
    else
      flash[:error] = "Registration not found"
      redirect_to(new_registration_search_path)
    end

  end

end
