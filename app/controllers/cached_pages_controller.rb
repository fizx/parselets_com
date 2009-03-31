class CachedPagesController < ApplicationController
  before_filter :admin_required
  
  def show
    render :text => CachedPage.find(params[:id]).content
  end
end
