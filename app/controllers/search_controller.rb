class SearchController < ApplicationController
  layout "simple"
  around_filter :dynamic_scope
  
  def index
    respond_to do |wants|
      wants.atom do
        do_search 
        @parselets = @search.results
        render :file => "/parselets/index"
      end

      wants.html do
        @feed = request.request_uri.sub("search", "search.atom")
        do_search 
        render "no_results" if @search.results.empty?
      end
      wants.json do
        do_search :class_names => "Parselet"
        render :json => remove_broken(@search.results).to_json
      end
      wants.xml do
        do_search :class_names => "Parselet"
        render :xml => remove_broken(@search.results).to_xml
      end
    end
  end

protected

  def remove_broken(parselets)
    parselets.inject([]) do |memo, parselet|
      memo << parselet if parselet.try(:works)
      memo
    end
  end

  def preprocess(q)
    q.gsub(%r[http://]i, '')
  end

  def do_search(options = {})
    class_names = options[:class_names] || (params[:classes] || "Parselet,Sprig,User,Domain").split(",")
    @search = Ultrasphinx::Search.new(:query => preprocess(params[:q]), 
      :class_names => class_names, 
      :page => params[:page] || 1,
      :per_page => 10)
    @search.excerpt
  end
end
