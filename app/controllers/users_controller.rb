class UsersController < ApplicationController
  layout 'clerk'
  include AuthenticatedSystem

  def new
    @user = User.new
  end
 
  def create
    logout_keeping_session!
    @user = User.new(params[:user])
    success = @user && @user.save
    if success && @user.errors.empty?
      self.current_user = @user
      redirect_back_or_default('/')
      flash[:notice] = "Thanks for signing up!"
    else
      flash[:error]  = "We couldn't set up your account. Sorry."
      render :action => 'new'
    end
  end
end
