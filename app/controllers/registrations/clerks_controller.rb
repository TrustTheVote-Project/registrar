class Registrations::ClerksController < ApplicationController
  layout 'clerk'
  before_filter :find_registration

  private

  def find_registration
    @registration = Registration.find(params[:registration_id]) if params[:registration_id] 
  end
end
