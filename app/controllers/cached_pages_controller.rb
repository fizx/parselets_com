class CachedPagesController < ApplicationController
  def show
    render :text => CachedPage.find(params[:id]).content
  end
end
