class ParseletsController < ApplicationController
  layout "simple"
  
  def code
    @parselet = Parselet.tmp_from_params(params[:root] || {}, params["root-command"])
    render :update do |page|
      page.replace_html "code_container", :partial => "code",
        :locals => {:path => "root", :data => @parselet.json }
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
end
