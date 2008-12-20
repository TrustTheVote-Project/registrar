class StateTransitionsController < ApplicationController

  def update
    @registration = Registration.find(params[:registration_id])
    @registration.acting_clerk = current_user
    @registration.activity_comment = params[:comment]
    transition = params[:transition]
    @registration.send("#{transition}!".to_sym)


    params[:next_url].blank? ? redirect_to(@registration) : redirect_to(params[:next_url])
  end

end
