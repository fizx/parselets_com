require "json"
require "rubygems"
# require "ruby-debug"

class ParseletsController < ApplicationController
  layout "simple"
  around_filter :dynamic_scope
  before_filter :include_editor, :only => [:new, :edit]
  before_filter :admin_required, :only => :destroy
  
  def index
    @parselets = Parselet.advanced_find :paginate, { :show_broken => true, :page => 1, :favorite_user => current_user }, params
    
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
      @parselet = find_parselet_by_params
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
  
  def show
    @parselet = find_parselet_by_params
    @versions = @parselet.paginated_versions :per_page => 10, :page => params[:history_page]
    @comments = @parselet.comments.paginate :per_page => 10, :page => params[:comments_page], :order => "created_at ASC"
    # @extra =    @parselet.versions.paginate :per_page => 10, :page => @versions.next_page, :order => "version DESC" # What does this do?
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @parselet }
      format.json { render :json => @parselet.to_json }
    end
  end

  def new
    @parselet = Parselet.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @parselet }
    end
  end

  def edit
    @parselet = find_parselet_by_params
  end

  def create
    @parselet = Parselet.tmp_from_params(params)

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

  def update
    @parselet = find_parselet_by_params
    @parselet.user_id = current_user.id
    # FIXME
    # Increment version ID
    # Update user ID

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
    @parselet = find_parselet_by_params
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
