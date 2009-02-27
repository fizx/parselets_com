require "json"
require "rubygems"
require "ruby-debug"
class ParseletsController < ApplicationController
  layout "simple"
  around_filter :dynamic_scope
  
  def code
    @editor_type = params["editor_helpful"].blank? ? "simple" : "helpful"
    @parselet = Parselet.tmp_from_params(params)
    render :update do |page|
      page.replace_html "code_container", :partial => "code",
        :locals => {:path => "root", 
                    :data => @parselet.data, 
                    :example_data => @parselet.example_data,
                    :editor_type => @editor_type }
      page << "$('root-command').value = ''"
    end
  end
  
  # GET /parselets
  # GET /parselets.xml
  def index
    @parselets = Parselet.paginate :page => params[:page]
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @parselets }
    end
  end

  # GET /parselets/1
  # GET /parselets/1.xml
  def show
    @parselet = Parselet.find_by_params(params)

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @parselet }
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
    @parselet = Parselet.find_by_params(params)
    @parselet.code = Parselet.tmp_from_params(params).code

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
end
