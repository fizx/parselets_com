class KarmasController < ApplicationController
  before_filter :admin_required
  # GET /karma
  # GET /karma.xml
  def index
    @karma = Karma.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @karma }
    end
  end

  # GET /karma/1
  # GET /karma/1.xml
  def show
    @karma = Karma.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @karma }
    end
  end

  # GET /karma/new
  # GET /karma/new.xml
  def new
    @karma = Karma.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @karma }
    end
  end

  # GET /karma/1/edit
  def edit
    @karma = Karma.find(params[:id])
  end

  # POST /karma
  # POST /karma.xml
  def create
    @karma = Karma.new(params[:karma])

    respond_to do |format|
      if @karma.save
        flash[:notice] = 'Karma was successfully created.'
        format.html { redirect_to(@karma) }
        format.xml  { render :xml => @karma, :status => :created, :location => @karma }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @karma.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /karma/1
  # PUT /karma/1.xml
  def update
    @karma = Karma.find(params[:id])

    respond_to do |format|
      if @karma.update_attributes(params[:karma])
        flash[:notice] = 'Karma was successfully updated.'
        format.html { redirect_to(@karma) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @karma.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /karma/1
  # DELETE /karma/1.xml
  def destroy
    @karma = Karma.find(params[:id])
    @karma.destroy

    respond_to do |format|
      format.html { redirect_to(karma_url) }
      format.xml  { head :ok }
    end
  end
end
