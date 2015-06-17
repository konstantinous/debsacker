require 'debsacker/system_gateway'
require 'date'

module Debsacker
  module Package
    class Changelog
      attr_writer :project_name, :author

      def project_name
        @project_name || File.basename(Dir.pwd)
      end

      def author
        @author || 'Made by debsacker <info@example.com>'
      end

      def lines(version)
        comment = Debsacker::SystemGateway.perform('git --no-pager log -1 --oneline')
        date = DateTime.now.strftime('%a, %e %b %Y %T %z')
        [
            "#{ project_name } (#{ version }) stable; urgency=medium",
            $/,
            $/,
            "  * #{ comment }",
            $/,
            " -- Made by #{ author }  #{ date }"
        ]
      end
    end
  end
end