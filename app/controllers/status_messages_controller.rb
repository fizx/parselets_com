class StatusMessagesController < ApplicationController
  before_filter :admin_required, :except => "index"
  # GET /status_messages
  # GET /status_messages.xml
  def index
    @status_messages = StatusMessage.all

    respond_to do |format|
      format.atom
      format.html # index.html.erb
      format.xml  { render :xml => @status_messages }
    end
  end

  # GET /status_messages/1
  # GET /status_messages/1.xml
  def show
    @status_message = StatusMessage.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @status_message }
    end
  end

  # GET /status_messages/new
  # GET /status_messages/new.xml
  def new
    @status_message = StatusMessage.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @status_message }
    end
  end

  # GET /status_messages/1/edit
  def edit
    @status_message = StatusMessage.find(params[:id])
  end

  # POST /status_messages
  # POST /status_messages.xml
  def create
    @status_message = StatusMessage.new(params[:status_message])

    respond_to do |format|
      if @status_message.save
        flash[:notice] = 'StatusMessage was successfully created.'
        format.html { redirect_to(@status_message) }
        format.xml  { render :xml => @status_message, :status => :created, :location => @status_message }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @status_message.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /status_messages/1
  # PUT /status_messages/1.xml
  def update
    @status_message = StatusMessage.find(params[:id])

    respond_to do |format|
      if @status_message.update_attributes(params[:status_message])
        flash[:notice] = 'StatusMessage was successfully updated.'
        format.html { redirect_to(@status_message) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @status_message.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /status_messages/1
  # DELETE /status_messages/1.xml
  def destroy
    @status_message = StatusMessage.find(params[:id])
    @status_message.destroy

    respond_to do |format|
      format.html { redirect_to(status_messages_url) }
      format.xml  { head :ok }
    end
  end
end
