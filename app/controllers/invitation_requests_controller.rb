class InvitationRequestsController < ApplicationController
  layout "simple"
  skip_before_filter :login_required, :only   => %w[new create]
  skip_before_filter :admin_required, :except => %w[new create]
  
  # GET /invitation_requests
  # GET /invitation_requests.xml
  def index
    @invitation_requests = InvitationRequest.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @invitation_requests }
    end
  end

  # GET /invitation_requests/1
  # GET /invitation_requests/1.xml
  def show
    @invitation_request = InvitationRequest.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @invitation_request }
    end
  end

  # GET /invitation_requests/new
  # GET /invitation_requests/new.xml
  def new
    @invitation_request = InvitationRequest.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @invitation_request }
    end
  end

  # GET /invitation_requests/1/edit
  def edit
    @invitation_request = InvitationRequest.find(params[:id])
  end

  # POST /invitation_requests
  # POST /invitation_requests.xml
  def create
    @invitation_request = InvitationRequest.new(params[:invitation_request])

    respond_to do |format|
      if @invitation_request.save
        flash[:notice] = 'InvitationRequest was successfully created.'
        format.html { redirect_to(@invitation_request) }
        format.xml  { render :xml => @invitation_request, :status => :created, :location => @invitation_request }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @invitation_request.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /invitation_requests/1
  # PUT /invitation_requests/1.xml
  def update
    @invitation_request = InvitationRequest.find(params[:id])

    respond_to do |format|
      if @invitation_request.update_attributes(params[:invitation_request])
        flash[:notice] = 'InvitationRequest was successfully updated.'
        format.html { redirect_to(@invitation_request) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @invitation_request.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /invitation_requests/1
  # DELETE /invitation_requests/1.xml
  def destroy
    @invitation_request = InvitationRequest.find(params[:id])
    @invitation_request.destroy

    respond_to do |format|
      format.html { redirect_to(invitation_requests_url) }
      format.xml  { head :ok }
    end
  end
end
