# Secrets Manager gem
WORK IN PROGRESS

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'secrets_manager'
```

And then execute:
```bash
$ bundle install
```

Or install it yourself as:
```bash
$ gem install secrets_manager
```

## Configure
Secret_manager uses `secrets.json` to configure how it handles secrets. Here is example of secrets.json file together with explaination of each option:

```json
{
  "app": {
    "id": "$environment/app",
    "input": "json",
    "type": "env",
    "path": "config/application.yml"
  },
  "tmp_file_secret": {
    "id": "production/tmp_secret",
    "input": "plaintext",
    "type": "file",
    "path": "tmp/tmp_secret.txt"
  }
}
```

#### ID
Represents secret_id used to retrieve secret from AWS Secret Manager.

It is possible to provide `$environment` which will be interpolated to:
- value provided in `--environment` or `-e` option when using CLI commands
- `Rails.env` when using Rails hook

#### INPUT
Defines format of secret coming from AWS Secret Manager. Two possible values: `json` and `plaintext`.

If specified as `json`, secret will be parsed in KEY-VALUE format.

If specified as `plaintext`, secret will be treated as string.

Defaults to `json`.

#### TYPE
Defines type of injection during boot. Two possible values: `env` and `file`.

If specified as `env`, secret will be injected into ENV variables during Rails boot.

If specified as `file`, file containing secret will be created during Rails boot.

Defaults to `env`.

#### PATH
Defines path where secrets will be pulled when using CLI.

Rails hook will check if this file exists. If it exists, Rails hook will ignore secrets which have this path specified in configuration.

## Authorization
Use same authorization process as AWS-CLI:
https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html

## Rails usage
In order to use Rails hook, it's enough to define this gem in Gemfile.

## CLI usage
Secrets Manager CLI provides several commands:

### HELP
List all commands and their descriptions:
```
secrets-manager help
```
You can use it with specific command:
```
secrets-manager help <command>
```

### PULL
Pull secrets locally:
```
secrets-manager pull
```
Options:
- `--environment` (`-e`) - interpolate $environment variable in configuration (defaults to **development**)
- `--path` (`-p`) - path to configuration file (defaults to **secrets.json**)

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
