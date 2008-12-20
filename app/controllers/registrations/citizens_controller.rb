class Registrations::CitizensController < ApplicationController
  layout 'citizen'
  before_filter :find_registration, :except => [:new, :create]

  def new
    @registration = Registration.new
    render :template => "registrations/new"
  end

  def edit
    render :template => "registrations/edit"
  end

  def create
    @registration = Registration.new(params[:registration])

    if @registration.save
      redirect_to(step2_registration_citizens_path(@registration))
    else
      render :template => "registrations/new"
    end
  end

  def update
    if @registration.update_attributes(params[:registration])
      redirect_to(step2_registration_citizens_path(@registration))
    else
      render :template => "registrations/edit"
    end
  end

  private

  def find_registration
    @registration = Registration.find(params[:registration_id]) if params[:registration_id] 
  end
end
