class SearchController < ApplicationController
  layout "simple"
  
  def index
    class_names = (params[:classes] || "Parselet,Sprig,User,Domain").split(",")
    @search = Ultrasphinx::Search.new(:query => preprocess(params[:q]), 
      :class_names => class_names, 
      :page => params[:page] || 1,
      :per_page => 10)
    @search.run
  end
protected
  def preprocess(q)
    q.gsub(%r[http://]i, '')
  end
end