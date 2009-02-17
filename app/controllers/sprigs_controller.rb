class SprigsController < ApplicationController
  layout "simple"
  
  before_filter :login_required, :except => %w[index show]
  
  # GET /sprigs
  # GET /sprigs.xml
  def index
    @sprigs = Sprig.paginate :page => params[:page]

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @sprigs }
    end
  end

  # GET /sprigs/1
  # GET /sprigs/1.xml
  def show
    @sprig = Sprig.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @sprig }
    end
  end

  # GET /sprigs/new
  # GET /sprigs/new.xml
  def new
    @sprig = Sprig.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @sprig }
    end
  end

  # GET /sprigs/1/edit
  def edit
    @sprig = Sprig.find(params[:id])
  end

  # POST /sprigs
  # POST /sprigs.xml
  def create
    @sprig = Sprig.new(params[:sprig])

    respond_to do |format|
      if @sprig.save
        flash[:notice] = 'Sprig was successfully created.'
        format.html { redirect_to(@sprig) }
        format.xml  { render :xml => @sprig, :status => :created, :location => @sprig }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @sprig.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /sprigs/1
  # PUT /sprigs/1.xml
  def update
    @sprig = Sprig.find(params[:id])

    respond_to do |format|
      if @sprig.update_attributes(params[:sprig])
        flash[:notice] = 'Sprig was successfully updated.'
        format.html { redirect_to(@sprig) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @sprig.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /sprigs/1
  # DELETE /sprigs/1.xml
  def destroy
    @sprig = Sprig.find(params[:id])
    @sprig.destroy

    respond_to do |format|
      format.html { redirect_to(sprigs_url) }
      format.xml  { head :ok }
    end
  end
end
