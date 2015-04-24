require 'debsacker'
require 'debsacker/options/version_factory'

module Debsacker
  module Options
    class Config

      def self.build
        dependencies = {}
        options = parse
        dependencies[:version] = Debsacker::Options::VersionFactory.build(options)
        dependencies[:control] =  Debsacker::Package::Control.new('debian/control')
        
        dependencies
      end

    private

      def self.parse
        options = {}
        OptionParser.new do |opts|
          opts.banner = 'Usage: debsacker [options]'

          opts.on('-pPACKAGE', '--package=PACKAGE', String, 'Define package version by tag, commit, datetime or explicit version name') do |v|
            options[:version] = v
          end

          opts.on('-d', '--[no-]distro', 'Add distro name to version name (default true)') do |add|
            options[:distro] = add
          end

          opts.on('-b', '--[no-]branch', 'Add branch name to version name (default false)') do |add|
            options[:branch] = add
          end

          opts.on_tail('-h', '--help', 'Show this message') do
            puts opts
            exit
          end

          opts.on_tail('-v', '--version', 'Show version') do
            puts Debsacker::VERSION
            exit
          end
        end.parse!

        options
      end
    end
  end
end