require "json"
require "rubygems"
require "ruby-debug"
class ParseletsController < ApplicationController
  layout "simple"
  around_filter :dynamic_scope
  before_filter :include_editor, :only => [:new, :edit]
    
  # GET /parselets
  # GET /parselets.xml
  def index
    @parselets = Parselet.paginate :page => params[:page]
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @parselets }
    end
  end

  def parse
    if params[:for_editor]
      @parselet = Parselet.tmp_from_params(params)
      params[:url] = @parselet.example_url
    else
      @parselet = Parselet.find_by_params(params)
      params[:url] ||= @parselet.example_url
    end

    @highlight_code = true

    @json = @parselet.pretty_parse(params[:url])
    
    respond_to do |format|
      format.html
      format.xml  { render :xml => @parselet.parse(params[:url], :output => :xml) }
      format.json { render :json => @json }
    end
  end
  
  # GET /parselets/1
  # GET /parselets/1.xml
  def show
    @parselet = Parselet.find_by_params(params)
    @comments = @parselet.comments.paginate :per_page => 10, :page => params[:comments_page], :order => "created_at ASC"
    @versions = @parselet.versions.paginate :per_page => 10, :page => params[:history_page], :order => "version DESC"
    @extra =    @parselet.versions.paginate :per_page => 10, :page => @versions.next_page, :order => "version DESC"
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @parselet }
      format.json { render :json => @parselet.to_json }
    end
  end

  # GET /parselets/new
  # GET /parselets/new.xml
  def new
    @parselet = Parselet.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @parselet }
    end
  end

  # GET /parselets/1/edit
  def edit
    @parselet = Parselet.find_by_params(params)
  end

  # POST /parselets
  # POST /parselets.xml
  def create
    @parselet = Parselet.tmp_from_params(params)
    @parselet.revision_user_id = current_user.id

    respond_to do |format|
      if @parselet.save
        flash[:notice] = 'Parselet was successfully created.'
        format.html { redirect_to(@parselet) }
        format.xml  { render :xml => @parselet, :status => :created, :location => @parselet }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @parselet.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /parselets/1
  # PUT /parselets/1.xml
  def update
    @parselet = Parselet.find_by_params(params, false)
    @parselet.code = Parselet.tmp_from_params(params).code
    @parselet.revision_user_id = current_user.id

    respond_to do |format|
      if @parselet.update_attributes(params[:parselet])
        flash[:notice] = 'Parselet was successfully updated.'
        format.html { redirect_to(@parselet) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @parselet.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /parselets/1
  # DELETE /parselets/1.xml
  def destroy
    @parselet = Parselet.find_by_params(params)
    @parselet.destroy

    respond_to do |format|
      format.html { redirect_to(parselets_url) }
      format.xml  { head :ok }
    end
  end
  
protected

  def include_editor
    @include_editor = true
  end
end
