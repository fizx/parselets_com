class SearchController < ApplicationController
  layout "simple"
  around_filter :dynamic_scope
  
  def index
    respond_to do |wants|
      wants.html { do_search }
      wants.json do
        do_search "Parselet"
        render :json => @search.results.to_json
      end
    end
  end

protected

  def preprocess(q)
    q.gsub(%r[http://]i, '')
  end

  def do_search(class_names = nil)
    class_names = class_names || (params[:classes] || "Parselet,Sprig,User,Domain").split(",")
    @search = Ultrasphinx::Search.new(:query => preprocess(params[:q]), 
      :class_names => class_names, 
      :page => params[:page] || 1,
      :per_page => 10)
    @search.run
  end
end