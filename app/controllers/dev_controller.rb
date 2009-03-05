class DevController < ApplicationController
  layout "simple"

  #skip_before_filter :login_required, :only   => %w[index]
  
  before_filter :find_parselet, :only => %w[ruby python]

  def index
    title "Development Tools"
  end
  
  def api
    title "The Parselets.com API"
  end

  def command_line
    title "Using Parsley from the command line"
  end

  def c
    title "Using Parsley from C and C++"
  end
  
  def help
    title "Getting Help"
  end
  
  def other_languages
    title "Using Parsley from Other Languages"
  end

  # Languages

  def ruby
    show_language "Ruby"
  end
  
  def python
    show_language "Python"
  end
  
protected

  def find_parselet
    @parselet = Parselet.find_by_id(params[:parselet_id])
  end

  def show_language(language)
    title "Using Parsley and Parselets with #{language}"
    render :layout => 'dev_language'
  end
  
  def title(string)
    @title = string
  end
end
