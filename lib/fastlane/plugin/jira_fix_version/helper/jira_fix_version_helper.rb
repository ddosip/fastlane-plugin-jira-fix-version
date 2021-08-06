require 'fastlane_core/ui/ui'

module Fastlane
  UI = FastlaneCore::UI unless Fastlane.const_defined?("UI")

  module Helper
    class JiraFixVersionHelper
      # class methods that you define here become available in your action
      # as `Helper::JiraFixVersionHelper.your_method`
      #
      def self.show_message
        UI.message("Hello from the jira_fix_version plugin helper!")
      end
    end
  end
end
