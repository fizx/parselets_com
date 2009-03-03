class RatingsController < ApplicationController
  before_filter :admin_required, :except => "create"
  # GET /ratings
  # GET /ratings.xml
  def index
    @ratings = Rating.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @ratings }
    end
  end

  # GET /ratings/1
  # GET /ratings/1.xml
  def show
    @rating = Rating.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @rating }
    end
  end

  # GET /ratings/new
  # GET /ratings/new.xml
  def new
    @rating = Rating.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @rating }
    end
  end

  # GET /ratings/1/edit
  def edit
    @rating = Rating.find(params[:id])
  end

  # POST /ratings
  # POST /ratings.xml
  def create
    if params[:parselet_id]
      if current_user
        @parselet = Parselet.find(params[:parselet_id])
        @rating = Rating.rate(@parselet, current_user, params[:score])
      else
        redirect_to login_url and return
      end
    else
      @rating = Rating.new(params[:rating])
    end
    @rating.score = params[:value].to_i if params[:value]

    respond_to do |format|
      if @rating.save
        # flash[:notice] = 'Rating was successfully created.'
        format.js {
          render :update do |page|
            page.replace_html "rating-count-#{@parselet.id}", :text => "&nbsp;#{@parselet.ratings.count}" 
          end
        }
        format.html { redirect_to(@rating) }
        format.xml  { render :xml => @rating, :status => :created, :location => @rating }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @rating.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /ratings/1
  # PUT /ratings/1.xml
  def update
    @rating = Rating.find(params[:id])

    respond_to do |format|
      if @rating.update_attributes(params[:rating])
        flash[:notice] = 'Rating was successfully updated.'
        format.html { redirect_to(@rating) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @rating.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /ratings/1
  # DELETE /ratings/1.xml
  def destroy
    @rating = Rating.find(params[:id])
    @rating.destroy

    respond_to do |format|
      format.html { redirect_to(ratings_url) }
      format.xml  { head :ok }
    end
  end
end
