# encoding: utf-8
require 'system_gateway'

class Requirements

  CONFIG_FILES = %w(changelog compat control)

  class << self

    def valid?
      config_files && packages
    end

    private

    def config_files
      CONFIG_FILES.each do |config_file|
        file = "debian/#{ config_file }"
        unless File.exist?(file)
          puts "There are no such file #{ file }"
          return false
        end
      end
    end

    def packages
      # Читаем control и ставим зависимости Build-Depends:
      depends,not_installed = [], []
      lines = File.readlines('debian/control')
      lines.each do |line|
        if line.start_with?('Build-Depends:')
          depends = (line.sub('Build-Depends:', '').gsub(/\(.*\)/, '').split(','))
        end
      end
      depends.each do |package|
        command = "dpkg-query -l #{ package.strip } 2>&1 |awk 'END { if($1==\"ii\") exit 0; else exit 1; }'"
        unless SystemGateway.perform_with_exit_code(command)
          not_installed.push(package)
        end
      end
      if not_installed.any?
        puts "Installing packages...."
        not_installed.each do |package|
          command = "apt-get install -y -q #{ package }"
          unless SystemGateway.perform_with_exit_code(command)
            puts "Error occurred during install package: #{ package }"
            return false
          end
        end
      end

      true
    end


  end

end
