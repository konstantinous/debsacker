# encoding: utf-8
require 'debsacker/system_gateway'

module Debsacker
  class Requirements

    CONFIG_FILES = %w(changelog compat control)

    class << self

      def valid?(dependencies)
        config_files && packages(dependencies)
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

        true
      end

      def packages(depends)
        depends.reject! do |package|
          command = "dpkg-query -l #{ package.strip } 2>&1 |awk 'END { if($1==\"ii\") exit 0; else exit 1; }'"
          Debsacker::SystemGateway.perform_with_exit_code(command)
        end

        if depends.any?
          puts "Installing packages...."
          depends.each do |package|
            command = "apt-get install -y -q #{ package.strip }"
            unless Debsacker::SystemGateway.perform_with_exit_code(command)
              puts "Error occurred during install package: #{ package }"
              return false
            end
          end
        end

        true
      end
    end
  end
end