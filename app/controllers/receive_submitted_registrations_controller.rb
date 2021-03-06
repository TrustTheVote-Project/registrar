class ReceiveSubmittedRegistrationsController < ApplicationController

  before_filter :login_required

  def update
    registrations = Registration.find_in_state(:all, :submitted)
    registrations.each do |registration|
      registration.acting_clerk = current_user
      registration.receive!
    end
    flash[:received_count] = registrations.size
    redirect_to(clerk_landing_path)
  end

end
