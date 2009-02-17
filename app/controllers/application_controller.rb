# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => 'a8f47e858a604be5160e638e9f6714d4'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
  
  around_filter :user_scope
  around_filter :dynamic_scope
  
protected
  def dynamic_scope
    scope = [:user, :domain].inject({}) do |scope, key|
      puts Kernel.const_get(key.to_s.classify).inspect
      if params[key] 
        model = Kernel.const_get(key.to_s.classify).find_by_key(params[key])
        scope[:conditions] ||= {}
        scope[:conditions]["#{key}_id".intern] = model && model.id
      end
      scope
    end
    puts scope.inspect
    
    Parselet.send(:with_scope, :find => scope) do
      Sprig.send(:with_scope, :find => scope) do
        yield
      end
    end
  end
  
  def user_scope
    Parselet.send :with_scope, :create => {:user_id => current_user && current_user.id} do
      yield
    end
  end
end
