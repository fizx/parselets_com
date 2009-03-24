class FavoritesController < ApplicationController

  before_filter :admin_required, :except => %w[toggle index]
  before_filter :login_required

  # GET /favorites
  # GET /favorites.xml
  def index
    @favorites = Favorite.paginate :order => "created_at DESC", :conditions => {:user_id => current_user && current_user.id}, :page => params[:page], :per_page => 10
    flash.now[:notice] = "Showing only your favorites"
    @favorites.map! {|f| f.favoritable }.select{|p| p.is_a?(Parselet)}
    @parselets = @favorites
    respond_to do |format|
      format.atom {
        render :file => "/parselets/index", :layout => "simple"
      }
      format.html {
        render :file => "/parselets/index", :layout => "simple"
      }
      format.xml  { render :xml => @parselets }
    end
  end

  def toggle
    @favorite = Favorite.toggle(params, current_user)
    render :layout => false
  end

  # GET /favorites/1
  # GET /favorites/1.xml
  def show
    @favorite = Favorite.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @favorite }
    end
  end

  # GET /favorites/new
  # GET /favorites/new.xml
  def new
    @favorite = Favorite.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @favorite }
    end
  end

  # GET /favorites/1/edit
  def edit
    @favorite = Favorite.find(params[:id])
  end

  # POST /favorites
  # POST /favorites.xml
  def create
    @favorite = Favorite.new(params[:favorite])

    respond_to do |format|
      if @favorite.save
        flash[:notice] = 'Favorite was successfully created.'
        format.html { redirect_to(@favorite) }
        format.xml  { render :xml => @favorite, :status => :created, :location => @favorite }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @favorite.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /favorites/1
  # PUT /favorites/1.xml
  def update
    @favorite = Favorite.find(params[:id])

    respond_to do |format|
      if @favorite.update_attributes(params[:favorite])
        flash[:notice] = 'Favorite was successfully updated.'
        format.html { redirect_to(@favorite) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @favorite.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /favorites/1
  # DELETE /favorites/1.xml
  def destroy
    @favorite = Favorite.find(params[:id])
    @favorite.destroy

    respond_to do |format|
      format.html { redirect_to(favorites_url) }
      format.xml  { head :ok }
    end
  end
end
