# jira_fix_version plugin

[![fastlane Plugin Badge](https://rawcdn.githack.com/fastlane/fastlane/master/fastlane/assets/plugin-badge.svg)](https://rubygems.org/gems/fastlane-plugin-jira_fix_version)

## Getting Started

This project is a [_fastlane_](https://github.com/fastlane/fastlane) plugin. To get started with `fastlane-plugin-jira_fix_version`, add it to your project by running:

```bash
fastlane add_plugin jira_fix_version
```

## About jira_fix_version

Updating fix versions for issues.

## Example

Check out the [example `Fastfile`](fastlane/Fastfile) to see how to use this plugin. Try it by cloning the repo, running `fastlane install_plugins` and `bundle exec fastlane test`.

```ruby
lane :set_fix_versions do
  jira_fix_version(
    username: "you",
    password: "123", # password or api token
    url: "https://jira.example.com",
    version: "0.1.0", # existing version
    project: "TEST",
    issues: "TEST-1, TEST-2" # comma separated issues keys
  )
end
```

## Options

```
fastlane action jira_fix_version
```

Key | Description | Env Var | Default
----|-------------|---------|--------
url | URL for Jira instance | FL_JIRA_URL |
username | Username for Jira instance | FL_JIRA_USERNAME |
password | Password for Jira or api token | FL_JIRA_PASSWORD |
project | Jira project name | FL_JIRA_PROJECT |
version | Jira project version | FL_JIRA_PROJECT_VERSION |
issues | Jira issues list | FL_JIRA_ISSUES |


## Run tests for this plugin

To run both the tests, and code style validation, run

```
rake
```

To automatically fix many of the styling issues, use
```
rubocop -a
```

## Issues and Feedback

For any other issues and feedback about this plugin, please submit it to this repository.

## Troubleshooting

If you have trouble using plugins, check out the [Plugins Troubleshooting](https://docs.fastlane.tools/plugins/plugins-troubleshooting/) guide.

## Using _fastlane_ Plugins

For more information about how the `fastlane` plugin system works, check out the [Plugins documentation](https://docs.fastlane.tools/plugins/create-plugin/).

## About _fastlane_

_fastlane_ is the easiest way to automate beta deployments and releases for your iOS and Android apps. To learn more, check out [fastlane.tools](https://fastlane.tools).
