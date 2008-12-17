ActionController::Routing::Routes.draw do |map|
  map.resources :registration_activities
  map.resource :receive_submitted_registrations
  map.resources :registration_searches
  map.resources :registrations do |registration|
    registration.resource :state_transitions
  end

  map.home '/home', :controller => 'Home', :action => 'index'
  map.default '/', :controller => 'Home', :action => 'index'
  map.citizen_landing1 '/citizen_landing1', :controller => 'CitizenLanding', :action => 'index1'
  map.citizen_landing2 '/citizen_landing2', :controller => 'CitizenLanding', :action => 'index2'
  map.clerk_landing '/clerk_landing', :controller => 'ClerkLanding', :action => 'index'
  map.tracking 'track/:registration_id', :controller => 'RegistrationActivities'

  map.login '/login', :controller => 'sessions', :action => 'new'
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.register '/register', :controller => 'users', :action => 'create'
  map.signup '/signup', :controller => 'users', :action => 'new'

  map.resources :users
  map.resource :session

end
