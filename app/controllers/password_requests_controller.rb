class PasswordRequestsController < ApplicationController
  layout "simple"
  skip_before_filter :login_required, :only => %w[new create]
  before_filter :admin_required, :except => %w[new create]
  # GET /password_requests
  # GET /password_requests.xml
  def index
    @password_requests = PasswordRequest.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @password_requests }
    end
  end

  # GET /password_requests/1
  # GET /password_requests/1.xml
  def show
    
    @password_request = PasswordRequest.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @password_request }
    end
  end

  # GET /password_requests/new
  # GET /password_requests/new.xml
  def new
    @password_request = PasswordRequest.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @password_request }
    end
  end

  # GET /password_requests/1/edit
  def edit
    @password_request = PasswordRequest.find(params[:id])
  end

  # POST /password_requests
  # POST /password_requests.xml
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

  # PUT /password_requests/1
  # PUT /password_requests/1.xml
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

  # DELETE /password_requests/1
  # DELETE /password_requests/1.xml
  def destroy
    @password_request = PasswordRequest.find(params[:id])
    @password_request.destroy

    respond_to do |format|
      format.html { redirect_to(password_requests_url) }
      format.xml  { head :ok }
    end
  end
end
