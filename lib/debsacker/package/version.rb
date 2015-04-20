require 'debsacker/system_gateway'

module Debsacker
  module Package
    class Version
      attr_accessor :add_distro, :add_branch

      def initialize(version_type)
        @version_type = version_type
      end

      def generate
        begin
          case @version_type
            when 'tag', nil
              version = tag
            when 'commit'
              version = commit
            when 'datetime'
              version = datetime
            else
              version = @version_type
          end
        rescue
          version = '0.1.0'
        end

        version << "-#{ branch_name }" if add_branch
        version << "-#{ distro_name }" if add_distro
        version
      end

    protected

      def distro_name
        @_distro_name ||= SystemGateway.perform('lsb_release -s -c').strip || 'unknown'
      end

      def branch_name
        @_branch_name ||= SystemGateway.perform('git rev-parse --abbrev-ref HEAD').strip.sub(/([\/\\])/,'-') || 'unknown'
      end

      def tag
        SystemGateway.perform('git symbolic-ref -q --short HEAD || git describe --tags --exact-match').strip
      end

      def commit
        SystemGateway.perform('git log -n 1 --pretty=format:"%H"').strip
      end

      def datetime
        Time.now.strftime('%Y%m%d%H%M%S')
      end
    end
  end
end