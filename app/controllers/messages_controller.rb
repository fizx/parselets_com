class MessagesController < ApplicationController
  before_filter :admin_required, :except => %w[index show new create destroy]
  layout "simple"

  def index
    if admin? && params[:user]
      admin_override = params[:user]
      using_admin_access
    else
      admin_override = nil
    end
    
    if params[:view] == 'from_me'
      @messages = Message.all :conditions => ['from_user_id = ? and deleted_at is null', admin_override || current_user.id]
    else
      @messages = Message.all :conditions => ['to_user_id = ? and deleted_at is null', admin_override || current_user.id]
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @messages }
    end
  end

  def show
    @message = Message.find(params[:id])
    return if bad_access_perms(@message)
    
    if current_user == @message.to_user && @message.read_at.nil?
      @message.read!
    end

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @message }
    end
  end

  def new
    @message = Message.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @message }
    end
  end

  def edit
    @message = Message.find(params[:id])
  end

  def create
    params[:message][:from_user_id] = current_user.try(:id)
    params[:message][:to_user_id] = User.find_by_login(params[:to].strip).try(:id)
    
    @message = Message.new(params[:message])
    return if bad_access_perms(@message)

    respond_to do |format|
      if @message.save
        flash[:notice] = 'Message was successfully created.'
        format.html { redirect_to(@message) }
        format.xml  { render :xml => @message, :status => :created, :location => @message }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @message.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @message = Message.find(params[:id])

    respond_to do |format|
      if @message.update_attributes(params[:message])
        flash[:notice] = 'Message was successfully updated.'
        format.html { redirect_to(@message) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @message.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @message = Message.find(params[:id])
    return if bad_access_perms(@message)
    @message.deleted_at = Time.now
    @message.save!

    respond_to do |format|
      format.html { redirect_to(messages_url) }
      format.xml  { head :ok }
    end
  end
  
protected

  def bad_access_perms(message)
    unless current_user && (message.from_user == current_user || message.to_user == current_user)
      if admin?
        using_admin_access
      else
        render :text => 'You cannot view this message.' and return true
      end
    end
    return false
  end
end
