class HomeController < ApplicationController
  layout "simple"
  
  def index
    @users = User.find :all, :limit => 5, :order => "cached_karma DESC"
    @feed = "/.atom"
    respond_to do |format|
      format.atom {
        @parselets = Parselet.find(:all, :order => "id DESC", :limit => 30)
        render :file => "/parselets/index"
      }
      format.html {
        @parselets = Parselet.find :all, :limit => 5, :order => "id DESC"
      } 
    end
  end
end
