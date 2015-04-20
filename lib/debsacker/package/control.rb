module Debsacker
  module Package
    class Control

      def initialize(file)
        @control_content = {}

        file_content(file).collect do |line|
          content = line.split(': ')

          @control_content[content.first.strip] = content.last.strip
        end
      end

      def [](attribute)
        value = @control_content[attribute]

        if attribute == 'Build-Depends'
          value.sub('Build-Depends:', '').gsub(/\(.*\)/, '').split(',').collect(&:strip)
        else
          value
        end
      end

    protected

      def file_content(file)
        File.readlines(file).collect(&:strip).reject(&:empty?)
      end
    end
  end
end