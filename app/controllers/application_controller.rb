# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  include HoptoadNotifier::Catcher
  
  filter_parameter_logging :password
  
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => 'a8f47e858a604be5160e638e9f6714d4'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
  
  before_filter :login_required
  
  around_filter :user_scope
  around_filter :invite_scope
  
  def admin_required
    unless authorized? && current_user.admin?
      access_denied
    end
  end
  
  def invite_required
    return true if authorized?

    session[:invite] = params[:invite]   if params[:invite]
    @invite = Invitation.find_by_code(session[:invite])

    return true if @invite && @invite.usable?
    
    flash[:notice] = @invite.nil? ? 
      "Please use an invitation code, or log in." : 
      "Your invitation code has expired or has been used too many times."
      
    access_denied
  end
  
protected
  def dynamic_scope
    scope = [:user, :domain].inject({}) do |scope, key|
      if params[key] 
        model = Kernel.const_get(key.to_s.classify).find_by_key(params[key])
        scope[:conditions] ||= {}
        scope[:conditions]["#{key}_id".intern] = model && model.id
      end
      scope
    end
    
    Parselet.send(:with_scope, :find => scope) do
      Sprig.send(:with_scope, :find => scope) do
        yield
      end
    end
  end
  
  def invite_scope
    User.send :with_scope, :create => {:invitation_id => @invite && @invite.id} do
      yield
    end
  end
  
  def user_scope
    this_user = {:create => {:user_id => current_user && current_user.id}}
    Invitation.send :with_scope, this_user do
      Parselet.send :with_scope, this_user do
        Sprig.send :with_scope, this_user do
          yield
        end
      end
    end
  end
end
