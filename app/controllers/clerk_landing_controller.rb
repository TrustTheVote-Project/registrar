class ClerkLandingController < ApplicationController
  layout 'clerk'

  before_filter :login_required

  def index
  end

end
