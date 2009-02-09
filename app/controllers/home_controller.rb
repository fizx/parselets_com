class HomeController < ApplicationController
  layout "simple"
  
  def index
    @users = User.top
    @parselets = Parselet.top
    @sprigs = Sprig.top
    @domains = Domain.top
  end
end
