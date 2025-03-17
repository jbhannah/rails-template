# Brooke's Rails Template

My personal preferred template for starting a new Rails application.

## Requirements

- Ruby
- rbenv
- [Bun][bun] (unless you specify [importmap-rails][importmap] or a
  different [jsbundling-rails][jsbundling] bundler)

## Usage

Use the template directly with `rails new`:

```bash
rails new APP_PATH [options] --template=https://raw.githubusercontent.com/jbhannah/rails-template/HEAD/template.rb
```

or run a bootstrapping script that uses Bundler to install Rails, then forwards
`options` to `bundle exec rails new`:

```bash
curl -L https://raw.githubusercontent.com/jbhannah/rails-template/HEAD/bootstrap.rb | ruby - APP_PATH [options]
```

and then start your app:

```bash
cd APP_PATH # you can skip this if APP_PATH is .
bin/dev
```

### Overrides

When running the bootstrapping script, the following options are passed to
`bundle exec rails new`:

```text
--css=postcss
--database=postgresql
--devcontainer
--javascript=bun
--template=https://raw.githubusercontent.com/jbhannah/rails-template/HEAD/template.rb
```

With the exception of `--template`, any options you specify will take priority
over these overrides.

[!CAUTION]
These overrides are not applied when using the template with `rails new`, only
when running it as a bootstrapping script.

### Updating

You can also (re)apply the template to an existing app:

```bash
bin/rails app:template LOCATION=https://raw.githubusercontent.com/jbhannah/rails-template/HEAD/template.rb
```

## Copyright

Copyright © 2025 Jesse Brooklyn Hannah. Licensed under the terms of the
[MIT License][license].

[bun]: https://bun.sh/
[importmap]: https://github.com/rails/importmap-rails
[jsbundling]: https://github.com/rails/jsbundling-rails
[license]: LICENSE.md
