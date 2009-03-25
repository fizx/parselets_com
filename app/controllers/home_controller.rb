class HomeController < ApplicationController
  layout "simple"
  
  def index
    @parselets = Parselet.advanced_find :all, :limit => 5, :favorite_user => current_user
    @users = User.find :all, :limit => 5, :order => "cached_karma DESC"
  end
end
