ActionController::Routing::Routes.draw do |map|
  map.resources :registration_activities
  map.resource :receive_submitted_registrations
  map.resources :registration_searches

  map.step1_new_registration_citizens "registrations/citizens/step1", :controller => 'registrations/citizens', :action => 'new'
  map.step1_edit_registration_citizens "registrations/:registration_id/citizens/step1", :controller => 'registrations/citizens', :action => 'edit'
  map.step1_create_registration_citizens "registrations/citizens/create", :controller => 'registrations/citizens', :action => 'create'
  map.step1_update_registration_citizens "registrations/:registration_id/citizens/update", :controller => 'registrations/citizens', :action => 'update', :method => :put
  
  citizen_steps = {
    :step2 => :get,
    :step3 => :get,
    :step4 => :get,
    :step5 => :get
  }

  clerk_steps = {
    :step2 => :get,
    :step3 => :get,
    :step4 => :get
  }

  map.resources :registrations  do |registration|
    registration.resource :citizens, :controller => 'registrations/citizens', :member => citizen_steps
    registration.resource :clerks, :controller => 'registrations/clerks', :member => clerk_steps
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
