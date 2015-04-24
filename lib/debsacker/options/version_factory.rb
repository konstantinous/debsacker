require 'debsacker/package/version'

module Debsacker
  module Options
    class VersionFactory
      def self.build(options)
        Debsacker::Package::Version.new(options[:version]).tap do |version|
          version.add_distro = options[:distro].nil? ? true : !!options[:distro]
          version.add_branch = !!options[:branch]
        end
      end
    end
  end
end