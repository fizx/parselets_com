ActionController::Routing::Routes.draw do |map|
  map.resources :status_messages

  map.resources :status_messages

  map.resources :favorites, :collection => { :toggle => :post }
  map.resources :ratings

  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.register '/register', :controller => 'users', :action => 'create'
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.search '/search', :controller => 'search', :action => 'index'
  map.search '/search.:format', :controller => 'search', :action => 'index'
  
  map.sprig_code "/sprig_code", :controller => 'parselets', :action => 'code'
  
  map.rate "/rate", :controller => 'ratings', :action => 'create'
  
  map.connect "/parse", :controller => 'parselets', :action => 'parse', :for_editor => true
  map.parse "/parse/:id", :controller => 'parselets', :action => 'parse'
  
  map.dev "/dev/:action/:id", :controller => 'dev'
  map.dev "/dev/:action", :controller => 'dev'
  
  map.versions "/parselets/:id/versions.:format", :controller => 'parselets', :action => 'versions'
  map.comments "/parselets/:id/comments.:format", :controller => 'parselets', :action => 'comments'
  
  map.edit_parselet "/parselets/:id/:version/edit", :controller => 'parselets', :action => 'edit'
  map.parselets_with_version "/parselets/:id/:version", :controller => 'parselets', :action => 'show'

  map.resources :karmas #lol!
  map.resources :comments
  map.resources :password_requests
  map.resources :cached_pages
  map.resources :invitation_requests
  map.resources :invitations
  map.resources :parselets, :member => { :parse => :get } do |p|
    p.resources :comments
    p.resources :ratings
  end
  map.resources :users, :member => { :reset_api_key => :post }
  map.resources :sprigs do |s|
    s.resources :comments
  end
  map.resources :domains
  map.resource  :session
  
  map.basic "/:controller/:action/:id"
  
  map.broken "broken.atom", :controller => "parselets", :action => "broken", :format => "atom"
  map.root_format ".atom", :controller => "home", :format => "atom"
  map.root :controller => "home"
end
