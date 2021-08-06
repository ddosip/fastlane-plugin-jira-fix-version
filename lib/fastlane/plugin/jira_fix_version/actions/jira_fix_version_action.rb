require 'fastlane/action'
require_relative '../helper/jira_fix_version_helper'

module Fastlane
  module Actions
    class JiraFixVersionAction < Action
      def self.run(params)
        Actions.verify_gem!('jira-ruby')
        require 'jira-ruby'

        options = {
          :username => params[:username],
          :password => params[:password],
          :site     => params[:url],
          :context_path => '',
          :auth_type => :basic,
          :read_timeout => 120
        }

        version = params[:version]
        project = params[:project]
        issues = params[:issues]

        client = JIRA::Client.new(options)

        # find project and version
        begin
          project_found = client.Project.find(project)
          UI.message("🔎 Finding matching version... => #{version}")
          version_found = project_found.versions.find { |v| v.name == "#{version}" }
          if version_found.nil?
            UI.message("🚸 No matching version found with #{version} in project #{project_found.name}")
            UI.message("Try to create...")

            newVersion = client.Version.build
            newVersion.save({
              "projectId" => project_found.id,
              "name" => version,
              "archived" => "false",
              "released" => "false"
            })

            version_found = newVersion
          end
        rescue JIRA::HTTPError => e
          fields = [e.code, e.message]
          fields << e.response.body if e.response.content_type == "application/json"
          UI.user_error!("❌ #{e} #{fields.join(', ')}")
        end

        UI.message("✅ Version found! => #{version_found.name}")

        # find issues 
        begin
          UI.message("🔎 Fetching issues... PROJECT = #{project_found.key} and key in (#{issues})")
          issues_found = client.Issue.jql("PROJECT = #{project_found.key} and key in (#{issues})", {fields: %w(summary status)})
          UI.user_error!("❌ Param issues count not equal to found issues count => #{issues_found.count} != #{issues.split(',').count}") if issues_found.count != issues.split(',').count
          UI.message("✅ Params issues #{issues.split(',').count}. Found issues #{issues_found.count}")
        rescue JIRA::HTTPError => e
          fields = [e.code, e.message]
          fields << e.response.body if e.response.content_type == "application/json"
          UI.user_error!("❌ #{e} #{fields.join(', ')}")
        end

        # исправляем fixVersions для задач
        begin
          issues_found.each do |issue|
            result = issue.save( { "update" => { "fixVersions" => [ {"add" => { "name" => "#{version_found.name}" } } ] } } )
            UI.message("✅ #{issue.key} - fixVersions => #{version_found.name}")
          end
        rescue JIRA::HTTPError => e
          fields = [e.code, e.message]
          fields << e.response.body if e.response.content_type == "application/json"
          UI.user_error!("❌ #{e} #{fields.join(', ')}")
        end
      end

      def self.description
        "fastlane_plugin_jira_fix_version"
      end

      def self.authors
        ["Dmitriy Osipov"]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.details
        # Optional:
        "fastlane_plugin_jira_fix_version"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :url,
                                       env_name: "FL_JIRA_URL",
                                       description: "URL for Jira instance",
                                       verify_block: proc do |value|
                                         UI.user_error!("No url for Jira given") if value.to_s.length == 0
                                       end),
          FastlaneCore::ConfigItem.new(key: :username,
                                       env_name: "FL_JIRA_USERNAME",
                                       description: "Username for Jira instance",
                                       verify_block: proc do |value|
                                         UI.user_error!("No username") if value.to_s.length == 0
                                       end),
          FastlaneCore::ConfigItem.new(key: :password,
                                       env_name: "FL_JIRA_PASSWORD",
                                       description: "Password or api token for Jira",
                                       sensitive: true,
                                       verify_block: proc do |value|
                                         UI.user_error!("No password") if value.to_s.length == 0
                                       end),
          FastlaneCore::ConfigItem.new(key: :project,
                                       env_name: "FL_JIRA_PROJECT",
                                       description: "Jira project name",
                                       sensitive: true,
                                       verify_block: proc do |value|
                                         UI.user_error!("No Jira project name") if value.to_s.length == 0
                                       end),
          FastlaneCore::ConfigItem.new(key: :version,
                                       env_name: "FL_JIRA_PROJECT_VERSION",
                                       description: "Jira project version",
                                       sensitive: true,
                                       is_string: false,
                                       verify_block: proc do |value|
                                         UI.user_error!("'version' value must be a String! Found #{value.class} instead.") unless value.kind_of?(String)
                                         UI.user_error!("No Jira project version") if value.to_s.length == 0
                                       end),
          FastlaneCore::ConfigItem.new(key: :issues,
                                       env_name: "FL_JIRA_ISSUES",
                                       description: "Jira issues list",
                                       sensitive: true,
                                       verify_block: proc do |value|
                                        UI.user_error!("No Jira issues list") if value.to_s.length == 0
                                       end),
        ]
      end

      def self.is_supported?(platform)
        # Adjust this if your plugin only works for a particular platform (iOS vs. Android, for example)
        # See: https://docs.fastlane.tools/advanced/#control-configuration-by-lane-and-by-platform
        #
        # [:ios, :mac, :android].include?(platform)
        true
      end
    end
  end
end
