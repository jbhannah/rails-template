# Brooke's Rails Template

My personal preferred template for starting a new Rails application.

## Usage

Use the template directly with `rails new`:

```bash
rails new APP_PATH [options] --template=https://raw.githubusercontent.com/jbhannah/rails-template/refs/heads/trunk/template.rb
```

or run a bootstrapping script that uses Bundler to install Rails, then forwards
`options` to `bundle exec rails new`:

```bash
curl -L https://raw.githubusercontent.com/jbhannah/rails-template/refs/heads/trunk/bootstrap.rb | ruby - APP_PATH [options]
```

### Overrides

When running the bootstrapping script, the following options are passed to
`bundle exec rails new`:

```text
--css=tailwind
--database=postgresql
--devcontainer
--template=https://raw.githubusercontent.com/jbhannah/rails-template/refs/heads/trunk/template.rb
```

With the exception of `--template`, any options you specify will take priority
over these overrides.

[!CAUTION]
These overrides are not applied when using the template with `rails new`, only
when running it as a bootstrapping script.

## Copyright

Copyright © 2025 Jesse Brooklyn Hannah. Licensed under the terms of the
[MIT License](LICENSE.md).
