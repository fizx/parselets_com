module ActionView
  module Helpers
    module UrlHelper
      def url_for_with_parselet_version_routing(options = {}, &block)
        if options.is_a?(Parselet)
          "/parselets/#{options.name}/#{options.version}"
        else
          url_for_without_parselet_version_routing(options, &block)
        end
      end
      alias_method_chain :url_for, :parselet_version_routing
    end
  end
end
