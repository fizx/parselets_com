ActionController::Routing::Routes.draw do |map|
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.register '/register', :controller => 'users', :action => 'create'
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.search '/search', :controller => 'search', :action => 'index'
  
  
  map.parselet_code "/parselet_code", :controller => 'parselets', :action => 'code'
  
  map.resources :password_requests
  map.resources :invitation_requests
  map.resources :invitations
  map.resources :parselets do |p|
    p.resources :parselet_versions
  end
  map.resources :parselet_versions
  map.resources :users
  map.resources :sprigs do |s|
    s.resources :sprig_versions
  end
  map.resources :domains
  map.resource  :session
  
  map.custom_parselet "/:login/:name", :controller => "parselets", :action => "show", :conditions => { :method => :get }

  map.root :controller => "home"
end
