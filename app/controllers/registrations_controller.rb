class RegistrationsController < ApplicationController
  def index
    @registrations = Registration.find(:all, :order => 'updated_at desc')
    render :layout => 'clerk'
  end

  def show
    @registration = Registration.find(params[:id])
    render :template => "/registrations/#{@registration.current_state.to_s}",
           :layout => (@registration.under_edit? || @registration.submitted?) ? 'citizen' : 'clerk'
  end

  def new
    @registration = Registration.new
    render :layout => 'citizen'
  end

  def edit
    @registration = Registration.find(params[:id])
    render :layout => 'citizen'
  end

  def create
    @registration = Registration.new(params[:registration])

    if @registration.save
      redirect_to(@registration)
    else
      render :action => 'new', :layout => 'citizen'
    end
  end

  def update
    @registration = Registration.find(params[:id])

    if @registration.update_attributes(params[:registration])
      redirect_to(@registration)
    else
      render :action => 'edit', :layout => @registration.under_edit? ? 'citizen' : 'clerk'
    end
  end

end
