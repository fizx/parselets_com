class HomeController < ApplicationController
  layout "simple"
  
  def index
    @users = User.find :all, :limit => 5, :order => "cached_karma DESC"
    @feed = "/parselets.atom"
    respond_to do |format|
      format.html {
        @parselets = Parselet.find :all, :limit => 5, :order => "id DESC"
      } 
    end
  end
end
