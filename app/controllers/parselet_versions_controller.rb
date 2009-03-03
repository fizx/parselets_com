class ParseletVersionsController < ApplicationController
  layout "simple"
  def index
    @parselet = Parselet.find(params[:parselet_id])
    @parselet_versions = Parselet::Version.paginate :conditions => {:parselet_id => params[:parselet_id]}, :page => params[:page], :order => 'version DESC'
  end

  def show
    @version = Parselet::Version.find(params[:id])
    @parselet = Parselet.find(@version.parselet_id)
    @parselet.revert_to @version.id
    render :template => "/parselets/show"
  end
  
  def edit
    version = Parselet::Version.find(params[:id])
    @parselet = version.parselet
    @parselet.revert_to version.id
    render :template => "/parselets/edit"
  end
  
  def update
    @parselet = Parselet::Version.find(params[:id]).parselet
    @parselet.code = Parselet.tmp_from_params(params).code

    respond_to do |format|
      if @parselet.update_attributes(params[:parselet_version] || params[:parselet])
        flash[:notice] = 'Parselet was successfully updated.'
        format.html { redirect_to(@parselet) }
        format.xml  { head :ok }
      else
        format.html { render :template => "/parselets/edit" }
        format.xml  { render :xml => @parselet.errors, :status => :unprocessable_entity }
      end
    end
  end
end
