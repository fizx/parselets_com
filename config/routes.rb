ActionController::Routing::Routes.draw do |map|
  map.resources :favorites, :collection => { :toggle => :post }
  map.resources :ratings

  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.register '/register', :controller => 'users', :action => 'create'
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.search '/search', :controller => 'search', :action => 'index'
  
  map.sprig_code "/sprig_code", :controller => 'parselets', :action => 'code'
  
  map.rate "/rate", :controller => 'ratings', :action => 'create'
  
  map.connect "/parse", :controller => 'parselets', :action => 'parse', :for_editor => true
  map.parse "/parse/:id", :controller => 'parselets', :action => 'parse'
  
  map.dev "/dev/:action/:id", :controller => 'dev'
  map.dev "/dev/:action", :controller => 'dev'
  
  map.edit_parselet "/parselets/:id/:version/edit", :controller => 'parselets', :action => 'edit'
  map.parselets_with_version "/parselets/:id/:version", :controller => 'parselets', :action => 'show'
  
  map.resources :comments
  map.resources :password_requests
  map.resources :cached_pages
  map.resources :invitation_requests
  map.resources :invitations
  map.resources :parselets, :member => { :parse => :get } do |p|
    p.resources :parselet_versions
    p.resources :comments
    p.resources :ratings
  end
  map.resources :parselet_versions
  map.resources :users
  map.resources :sprigs do |s|
    s.resources :sprig_versions
    s.resources :comments
  end
  map.resources :domains
  map.resource  :session
  
  map.root :controller => "home"
end
