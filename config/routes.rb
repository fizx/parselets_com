ActionController::Routing::Routes.draw do |map|
  map.resources :invitation_requests

  map.resources :invitations

  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.register '/register', :controller => 'users', :action => 'create'
  map.signup '/signup', :controller => 'users', :action => 'new'
  

  map.resources :users
  map.resources :sprigs
  map.resources :parselets
  map.resources :domains
  
  map.resource :session

  map.root :controller => "home"
  
  map.parselet '/:login/:name', :controller => "parselets", :action => "show"
  
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
