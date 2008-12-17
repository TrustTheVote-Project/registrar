class StateTransitionsController < ApplicationController

  def update
    @registration = Registration.find(params[:registration_id])
    @registration.acting_clerk = current_user
    @registration.activity_comment = params[:comment]
    transition = params[:transition]
    @registration.send("#{transition}!".to_sym)
    redirect_to(@registration)
  end

end
