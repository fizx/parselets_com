# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  
  filter_parameter_logging :password
  
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  # protect_from_forgery # :secret => 'a8f47e858a604be5160e638e9f6714d4'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
  
  before_filter :fix_domain
  before_filter :reject_api_requests
  before_filter :show_status
  
  def render_404
    render :text => File.read(RAILS_ROOT + "/public/404.html"), :status => 404
  end
  
  def show_status
    @status = StatusMessage.find :first, :order => "id DESC"
    @status = nil unless @status && @status.active?
  end
  
  around_filter :user_scope
  
  def fix_domain
    if RAILS_ENV == "production" && request.host != "parselets.com"
      uri = URI.parse(request.request_uri)
      uri.host = "parselets.com"
      uri.scheme = "http"
      redirect_to uri.to_s, :status=>301
      return false
    end
    true
  end
  
  def reject_api_requests
    if api_request?
      logger.warn "API Request attempted on disallowed page."
      render :text => 'Sorry, API requests are not allowed on this page.', :status => :forbidden and return
    end
  end
        
  def admin_required
    unless authorized? && admin?
      access_denied(not_an_admin_error = true)
    else
      @admin_access = true
    end
  end
  
  def find_parselet_by_params
    Parselet.find_by_params(params, :favorite_user => current_user)
  end
  
  def admin?
    current_user && current_user.admin?
  end
  helper_method :admin?
    
protected

  # Scopes to user_id={kyle's user id} when query like ?user=kyle.
  # Scopes to domain_id when query like ?domain=google.com
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
      yield
    end
  end
  
  def user_scope
    this_user = {:create => {:user_id => current_user && current_user.id}}
    StatusMessage.send :with_scope, this_user do
      Parselet.send :with_scope, this_user do
        Comment.send :with_scope, this_user do
          Rating.send :with_scope, this_user do
            Favorite.send :with_scope, this_user do
              yield
            end
          end
        end
      end
    end
  end
end
