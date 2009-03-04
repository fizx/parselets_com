class DevController < ApplicationController
  layout "simple"

  #skip_before_filter :login_required, :only   => %w[index]

  def index
  end
end
