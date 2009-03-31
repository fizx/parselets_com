class HomeController < ApplicationController
  layout "simple"
  
  def index
    @users = User.find :all, :limit => 5, :order => "cached_karma DESC"
    @feed = "/parselets.atom"
    @parselets = Parselet.advanced_find :paginate, { :per_page => 5, :page => 1, :favorite_user => current_user }, params
  end
  
  def email
  end
end
