URL_FOR_PARSELET_VERSION_ROUTING = <<-STR
  def url_for_with_parselet_version_routing(options = {}, &block)
    if options.is_a?(Parselet)
      "/parselets/\#{options.name}/\#{options.version}"
    else
      url_for_without_parselet_version_routing(options, &block)
    end
  end
  alias_method_chain :url_for, :parselet_version_routing
STR

module ActionView
  module Helpers
    module UrlHelper
      eval URL_FOR_PARSELET_VERSION_ROUTING
    end
  end
end

module ActionController
  class Base
    eval URL_FOR_PARSELET_VERSION_ROUTING
  end
end
