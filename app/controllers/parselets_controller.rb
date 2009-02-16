require "json"
class ParseletsController < ApplicationController
  layout "simple"
  before_filter :login_required, :except => %w[index show]
  
  def code
    @editor_type = params["editor_helpful"].blank? ? "simple" : "helpful"
    data = json_from_params
    render :update do |page|
      page.replace_html "code_container", :partial => "code",
        :locals => {:path => "root", 
                    :data => data, 
                    :editor_type => @editor_type }
      page << "$('root-command').value = ''"
    end
  end
  
  # GET /parselets
  # GET /parselets.xml
  def index
    @parselets = Parselet.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @parselets }
    end
  end

  # GET /parselets/1
  # GET /parselets/1.xml
  def show
    @parselet = Parselet.find(params[:id])

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
    @parselet = Parselet.find(params[:id])
  end

  # POST /parselets
  # POST /parselets.xml
  def create
    @parselet = Parselet.new(params[:parselet])
    @parselet.code = code_from_params

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
    @parselet = Parselet.find(params[:id])
    @parselet.code = code_from_params

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
    @parselet = Parselet.find(params[:id])
    @parselet.destroy

    respond_to do |format|
      format.html { redirect_to(parselets_url) }
      format.xml  { head :ok }
    end
  end
protected
  
  def code_from_params
    params[:root] ?
      Parselet.tmp_from_params(params[:root] || {}, params["root-command"]).code :
      params[:code]
  end
  
  def json_from_params
    tmp = code_from_params 
    tmp && OrderedJSON.parse(tmp)
  end
end
