class HomeController < ApplicationController
  layout "simple"
  
  def index
    @parselets = Parselet.advanced_find :all, :limit => 5
  end
end
