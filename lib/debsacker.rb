# encoding: utf-8
require 'debsacker/version'
require 'requirements'
require 'system_gateway'
require 'yaml'
require 'pry'
require 'date'

module Debsacker

  class Creator
    class << self
      @vesion_type = ''

      def go(param)
        @version_type = param
        self.create
      end

      def check_version
        begin
          distro = SystemGateway.perform('lsb_release -s -c').strip || 'unknown'
          branch = SystemGateway.perform('git rev-parse --abbrev-ref HEAD').strip.sub(/([\/\\])/,'-')|| 'unknown'
          case @version_type
          when 'tag'
            version = SystemGateway.perform('git describe --tags $(git rev-list --tags --max-count=1)').strip
            version.delete('A-Z<=~()').concat('-').concat(branch)
          when 'commit'
            version = SystemGateway.perform('git log -n 1 --pretty=format:"%H"').strip
          when 'datetime' 
            version = Time.now.strftime('%Y%m%d%H%M%S')
            version.delete('A-Z<=~()').concat('-').concat(branch)
          else
            version = @version_type
          end
        rescue
          version = '0.1.0'.concat('-unknown')
        end
      end

      def generate_changelog
        comment = SystemGateway.perform('git --no-pager log -1 --oneline')
        date = DateTime.now.strftime("%a, %e %b %Y %T %z")
        project = File.basename(Dir.pwd)
        lines = ["#{ project } (#{ self.check_version }) stable; urgency=medium",
          "  * #{ comment }",
          " -- Made by debsacker <info@example.com>  #{ date }"]
        return lines
      end

      def clear
        puts "deleting temporary files...."
        SystemGateway.perform('git clean -fd')
        SystemGateway.perform('git reset --hard')
      end

      def create
        puts "\033[32mShow me what u got!\033[0m\n\n"
        begin
          File.open('debian/changelog', 'w') do |file|
            self.generate_changelog.each do |line|
              file.puts("#{ line }\n")
            end
          end
        rescue
          return 'Can\'t create debian/changelog file...'
        end
        if Requirements.valid?
          if SystemGateway.perform_with_exit_code('dpkg-buildpackage -uc -us -b')
            clear
            begin
              File.open('current_version', 'w'){ |file| file.write(self.check_version) }
            rescue
              puts "\033[31mCan't write version into version file!\033[0m"
            end
            puts "\033[32mYey! We have new package!\033[0m"
          else
            puts "\033[31mError while running 'dpkg-buildpackage'!\033[0m"
            exit 1
          end
        else
          'Requirements are not satisfied :,('
        end
      end

    end

  end

end
