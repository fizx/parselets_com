class CommentsController < ApplicationController
  before_filter :admin_required, :only => %w[update destroy]
  
  unless filter_chain.any?{|filter| filter.method == :login_required}
      before_filter :login_required, :only => %w[create]
    end
  #   
  # GET /comments
  # GET /comments.xml
  def index
    if params[:parselet_id]
      params[:id] = params[:parselet_id]
      params[:type] = params[:parselet_type]
    end
    
    # unless params[:id] && params[:type]
    #   redirect_to '/' and return unless admin?
    #   @admin_access = true
    # end    
    
    conditions = {}
    conditions = {:commentable_type => params[:type], :commentable_id => params[:id]} if params[:id] && params[:type]
    @comment = Comment.new(conditions)

    if params[:merged] && params[:type] == 'Parselet'
      conditions = ['commentable_type = ? and commentable_id in (?)', params[:type], Parselet.find(params[:id]).versions.map(&:id)]
    end
    @comments = Comment.paginate :page => params[:comments_page], :conditions => conditions, :order => "created_at ASC"

    respond_to do |format|
      format.atom {
        @comments  = Comment.find :all, :limit => 30, :order => "id DESC"
        render :file => "/parselets/comments"
      }
      format.html # index.html.erb
      format.xml  { render :xml => @comments }
    end
  end

  # GET /comments/1
  # GET /comments/1.xml
  def show
    @comment = Comment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @comment }
    end
  end

  # GET /comments/new
  # GET /comments/new.xml
  def new
    @comment = Comment.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @comment }
    end
  end

  # GET /comments/1/edit
  def edit
    @comment = Comment.find(params[:id])
  end

  # POST /comments
  # POST /comments.xml
  def create
    @comment = Comment.new(params[:comment])
    
    params[:comments_page] = 1 if params[:comments_page] == ''

    respond_to do |format|
      if @comment.save
        domid = dom_id(@comment.commentable)
        flash[:notice] = 'Comment was successfully created.'
        format.html { redirect_to(@comment) }
        format.xml  { render :xml => @comment, :status => :created, :location => @comment }
        format.js {
          flash[:notice] = nil
          render :update do |page|
            page.replace "comments_area_#{domid}", :partial => "comments", :locals => {
                         :comments => @comment.commentable.comments.paginate(:page => params[:comments_page], 
                                                                             :order => "created_at ASC", :per_page => 10), 
                         :new_comment => @comment.commentable.comments.new }
            page.replace_html "add_comment_#{domid}", :text => "Thank you for your comment."
            page << "$(\"#add_comment_#{domid}\").fadeOut(5000, function() { $(this).remove(); })"
            page.replace_html "comments_#{dom_id(@comment.commentable)}", :text => (@comment.commentable.comments_count + 1).to_s
          end
        }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /comments/1
  # PUT /comments/1.xml
  def update
    @comment = Comment.find(params[:id])

    respond_to do |format|
      if @comment.update_attributes(params[:comment])
        flash[:notice] = 'Comment was successfully updated.'
        format.html { redirect_to(@comment) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.xml
  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to("/") }
      format.xml  { head :ok }
    end
  end
end
