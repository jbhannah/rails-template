# Jesse Brooklyn Hannah's Rails Template

My Rails app quickstart template.

## Bootstrapping

```bash
./bootstrap.sh target_dir [args]
```

What [the script](bootstrap.sh) does:

1. Creates a directory at `target_dir`
2. Copies [`Gemfile`](Gemfile) to the target directory
3. Writes a `.ruby-version` file with the current `ruby` command's version
4. Installs the latest (non-prerelease) Rails version
5. Generates a Rails app in the target directory with `bundle exec rails new`

`rails new` runs with a default set of arguments:

```bash
--skip-test --database postgresql -m /path/to/rails-template/template.rb -f
```

plus any additional arguments that are passed to the script after the target
directory (see `rails new --help` for arguments). `--skip-test` and `--database`
in the default arguments can (but probably shouldn't) be overridden with
`--no-skip-test` and an additional `--database` argument, respectively.

## Template

### Development

#### Gems

- [Annotate](https://github.com/ctran/annotate_models)
- [Brakeman](https://brakemanscanner.org/)
- [Overcommit](https://github.com/sds/overcommit)
- [Rubocop](https://rubocop.org)
- [Solargraph](https://solargraph.org)

#### Features

- Configures [Rubocop][rc] and [Solargraph][sg] with useful defaults
- Configures auto-annotation of models with YARD comments for attributes
- Installs git hooks with Overcommit to run Rubocop, Brakeman, and RSpec
- Configures [Dependabot][db] for Bundler and GitHub Actions updates
- Configures CI on [GitHub Actions][ga]
  - Adds `x86_64-linux` to the list of Bundler platforms
  - Runs and caches `bundle install`
  - Runs Brakeman, Rubocop, and RSpec
  - Configures [CodeQL][cq]
  - Enables [automerge][am] for Dependabot PRs
- Writes a default [`README`](template/README.md.erb) and
  [`LICENSE`](template/LICENSE.md)
- Adds RSpec's `examples.txt` and SimpleCov output to `.gitignore`
- Autocorrects all auto-correctable Rubocop issues
- Initializes a git repository and creates an initial commit

### Application

#### Gems

- [ServiceActor](https://github.com/sunny/actor)

#### Features

- Configures [PostgreSQL][ps] and Active Record to use UUID primary keys
- Sets up development and test databases
- Migrates the database and creates `db/schema.rb`
- Adds common inflection acronyms (API, HTTP, JWT)
- Adds [`AttributeProtector`][ap] and [`ScopeInverter`][si] model concerns

### Testing

#### Gems

- [RSpec](https://rspec.info)
- [factory_bot](https://github.com/thoughtbot/factory_bot)
- [Faker](https://github.com/faker-ruby/faker)
- [Mocha](https://mocha.jamesmead.org)
- [SimpleCov](https://github.com/simplecov-ruby/simplecov)

#### Features

- Generates HTML and Cobertura formatted coverage reports with [SimpleCov][sc]
- [Tests][as] the `AttributeProtector` model concern
- [Configures RSpec](template/spec/spec_helper.rb) to use Mocha for mocking
- Includes Active Support time helpers and factory_bot methods in [specs][rh]
- Adds a `be_the_same_time_as` [matcher][tm] for safe timestamp comparisons

## Licensing

Copyright © 2022 by [Jesse Brooklyn Hannah](https://jbhannah.net). Template
released under the terms of the [MIT License](LICENSE.md). By default, apps
include the [GNU Affero General Public License version 3](template/LICENSE.md).

[am]: template/.github/workflows/dependabot.yml
[ap]: template/app/models/concerns/attribute_protector.rb
[as]: template/spec/models/concerns/attribute_protector_spec.rb
[cq]: template/.github/workflows/codeql.yml
[db]: template/.github/dependabot.yml
[ga]: template/.github/workflows/ci.yml.erb
[ps]: template/db/migrate/0_enable_pgcrypto.rb
[rc]: template/.rubocop.yml
[rh]: template/spec/rails_helper.rb
[sc]: template/.simplecov
[sg]: template/.solargraph.yml
[si]: template/app/models/concerns/scope_inverter.rb
[tm]: template/spec/support/matchers/time.rb
