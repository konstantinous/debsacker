# encoding: utf-8
require 'debsacker/version'
require 'debsacker/requirements'
require 'debsacker/system_gateway'
require 'debsacker/package'

module Debsacker
  class Creator
    class << self
      def go(version, control)
        creator = new(version, control)
        creator.create
      end
    end

    def initialize(version, control)
      @version = version.generate
      @control = control
      @changelog = Debsacker::Package::Changelog.new.tap do |changelog|
        changelog.project_name = @control['Package']
        changelog.author = @control['Maintainer']
      end
    end

    def create
      puts "\033[32mShow me what u got!\033[0m\n\n"
      begin
        File.open('debian/changelog', 'w') do |file|
          @changelog.lines(@version).each do |line|
            file.print(line)
          end
        end
      rescue
        return 'Can\'t create debian/changelog file...'
      end
      if Debsacker::Requirements.valid?(@control['Build-Depends'])
        if Debsacker::SystemGateway.perform_with_exit_code('dpkg-buildpackage -uc -us -b')
          clear
          begin
            File.open('current_version', 'w'){ |file| file.write(@version) }
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

    def clear
      puts 'deleting temporary files....'
      Debsacker::SystemGateway.perform('git clean -fd')
      Debsacker::SystemGateway.perform('git reset --hard')
    end
  end
end