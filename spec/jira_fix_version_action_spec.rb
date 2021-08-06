describe Fastlane::Actions::JiraFixVersionAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The jira_fix_version plugin is working!")

      Fastlane::Actions::JiraFixVersionAction.run(nil)
    end
  end
end
