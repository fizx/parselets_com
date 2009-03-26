class HomeController < ApplicationController
  layout "simple"
  
  def index
    @parselets = Parselet.find :all, :limit => 5, :order => "id DESC"
    @users = User.find :all, :limit => 5, :order => "cached_karma DESC"
  end
end
