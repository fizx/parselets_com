class PasswordRequestsController < ApplicationController
  layout "simple"
  before_filter :login_required, :except => %w[new create]
  before_filter :admin_required, :except => %w[new create]

  def index
    @password_requests = PasswordRequest.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @password_requests }
    end
  end

  def show
    @password_request = PasswordRequest.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @password_request }
    end
  end

  def new
    @password_request = PasswordRequest.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @password_request }
    end
  end

  def edit
    @password_request = PasswordRequest.find(params[:id])
  end

  def create
    @password_request = PasswordRequest.new(params[:password_request])

    respond_to do |format|
      if @password_request.save
        flash[:notice] = 'PasswordRequest was successfully created.'
        format.html { redirect_to(@password_request) }
        format.xml  { render :xml => @password_request, :status => :created, :location => @password_request }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @password_request.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @password_request = PasswordRequest.find(params[:id])

    respond_to do |format|
      if @password_request.update_attributes(params[:password_request])
        flash[:notice] = 'PasswordRequest was successfully updated.'
        format.html { redirect_to(@password_request) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @password_request.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @password_request = PasswordRequest.find(params[:id])
    @password_request.destroy

    respond_to do |format|
      format.html { redirect_to(password_requests_url) }
      format.xml  { head :ok }
    end
  end
end
