ActionController::Routing::Routes.draw do |map|

  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.register '/register', :controller => 'users', :action => 'create'
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.search '/search', :controller => 'search', :action => 'index'
  
  
  map.parselet_code "/parselet_code", :controller => 'parselets', :action => 'code'
  
  map.resources :invitation_requests
  map.resources :invitations
  map.resources :parselets
  map.resources :users
  map.resources :sprigs
  map.resources :domains
  map.resource  :session
  
  map.custom_parselet "/:login/:name", :controller => "parselets", :action => "show", :conditions => { :method => :get }

  map.root :controller => "home"
end
