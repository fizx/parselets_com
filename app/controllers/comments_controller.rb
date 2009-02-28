class CommentsController < ApplicationController
  # GET /comments
  # GET /comments.xml
  def index
    @comments = Comments.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @comments }
    end
  end

  # GET /comments/1
  # GET /comments/1.xml
  def show
    @comments = Comments.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @comments }
    end
  end

  # GET /comments/new
  # GET /comments/new.xml
  def new
    @comments = Comments.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @comments }
    end
  end

  # GET /comments/1/edit
  def edit
    @comments = Comments.find(params[:id])
  end

  # POST /comments
  # POST /comments.xml
  def create
    @comments = Comments.new(params[:comments])

    respond_to do |format|
      if @comments.save
        flash[:notice] = 'Comments was successfully created.'
        format.html { redirect_to(@comments) }
        format.xml  { render :xml => @comments, :status => :created, :location => @comments }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @comments.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /comments/1
  # PUT /comments/1.xml
  def update
    @comments = Comments.find(params[:id])

    respond_to do |format|
      if @comments.update_attributes(params[:comments])
        flash[:notice] = 'Comments was successfully updated.'
        format.html { redirect_to(@comments) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @comments.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.xml
  def destroy
    @comments = Comments.find(params[:id])
    @comments.destroy

    respond_to do |format|
      format.html { redirect_to(comments_url) }
      format.xml  { head :ok }
    end
  end
end
