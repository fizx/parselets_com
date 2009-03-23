class UsersController < ApplicationController
  layout "simple"
  skip_before_filter :login_required, :only => %w[new create]
  around_filter :invite_required, :only => %w[new create]
  before_filter :redirect_unless_owner_or_admin, :only => %w[edit update]
  
  def index
    @users = User.paginate :page => params[:page], :per_page => 50, :order => "login ASC"

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end
    
  # render new.rhtml
  def new
    @user = User.new
  end
  
  def show
    redirect_to :controller => 'parselets', :action => 'index', :user => params[:id]
  end
  
  def edit
  end
  
  def update
    params[:user][:login] = @user.login
    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = 'Profile was successfully updated.'
        format.html { redirect_to(@user) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end
 
  def create
    logout_keeping_session!
    @user = User.new(params[:user])
    success = @user && @user.save
    if success && @user.errors.empty?
            # Protects against session fixation attacks, causes request forgery
      # protection if visitor resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset session
      self.current_user = @user # !! now logged in
      redirect_back_or_default('/')
      flash[:notice] = "Thanks for signing up!"
    else
      flash[:error]  = "We couldn't set up that account, sorry.  Please try again, or contact an admin (link is above)."
      render :action => 'new'
    end
  end

protected

  def redirect_unless_owner_or_admin
    @user = User.find_by_login(params[:id])
    if @user != current_user
      unless admin?
        redirect_to :action => 'edit', :id => current_user and return
      end
      @admin_access = true
    end
  end
end
