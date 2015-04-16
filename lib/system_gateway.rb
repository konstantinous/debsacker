# encoding: utf-8
class SystemGateway

  def self.perform(command)
    puts "\033[34mPerforming: #{ command }\033[0m"
    IO.popen(command).read
  end

  def self.perform_with_exit_code(command)
    puts "\033[34mPerforming: #{ command }\033[0m"
    system(command)
    $?.success?
  end

end
