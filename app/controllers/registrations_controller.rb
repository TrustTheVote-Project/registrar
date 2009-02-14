class RegistrationsController < ApplicationController
  def index
    @registrations = Registration.find(:all, :order => 'updated_at desc')
    render :layout => 'clerk'
  end

  def show
    @registration = Registration.find(params[:id])
    if @registration.current_state == :rejected
      rejection = @registration.activities.detect { |a| a.kind == :rejected }
      @reason, @comment = rejection.reason_and_comment
    end
    render :template => "/registrations/#{@registration.current_state}",
           :layout => (@registration.under_edit? || @registration.submitted?) ? 'citizen' : 'clerk'
  end

  def step2
    render :action => :show
  end

  def new
    @registration = Registration.new
    respond_to do |format|
      format.js {}
      format.html { render :layout => 'citizen' }
    end
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
