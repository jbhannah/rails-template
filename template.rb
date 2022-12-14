gem 'service_actor-rails'

gem_group :development, :test do
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'rspec-rails'
end

gem_group :development do
  gem 'annotate', require: false
  gem 'brakeman', require: false
  gem 'overcommit', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
  gem 'solargraph', require: false
end

gem_group :test do
  gem 'mocha'
  gem 'simplecov', require: false
  gem 'simplecov-cobertura', require: false
end

initializer 'generators.rb', <<~RUBY
  Rails.application.config.generators do |g|
    g.orm :active_record, primary_key_type: :uuid
  end
RUBY

initializer 'inflections.rb', <<~RUBY
  ActiveSupport::Inflector.inflections(:en) do |inflect|
    inflect.acronym 'API'
    inflect.acronym 'HTTP'
    inflect.acronym 'JWT'
  end
RUBY

Dir.glob('**/*', File::FNM_DOTMATCH, base: "#{__dir__}/template").each do |file|
  source_file = "#{__dir__}/template/#{file}"

  next unless File.file?(source_file)

  if File.extname(file) == '.erb'
    template source_file, File.join(File.dirname(file), File.basename(file, '.erb'))
  else
    copy_file source_file, file
  end
end

after_bundle do
  git :init

  append_to_file '.gitignore', <<~TEXT

    /coverage
    /spec/examples.txt
  TEXT

  generate 'annotate:install', '-s'
  generate 'rspec:install', '-s'

  rails_command 'db:create'
  rails_command 'db:migrate'

  run 'bundle binstubs brakeman overcommit rspec-core rubocop solargraph'
  run 'bin/rubocop -A'

  run 'bin/overcommit -i'

  git add: '.'
  git commit: %Q{-m 'Initial commit'}
end
