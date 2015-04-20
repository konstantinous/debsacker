# encoding: utf-8
module Debsacker
  class SystemGateway
    class << self
      def perform(command)
        puts "\033[34mPerforming: #{ command }\033[0m"
        IO.popen(command).read
      end

      def perform_with_exit_code(command)
        puts "\033[34mPerforming: #{ command }\033[0m"
        system(command)
        $?.success?
      end
    end
  end
end