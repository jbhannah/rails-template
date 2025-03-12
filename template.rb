#!/usr/bin/env ruby

if caller.empty?
  puts "Running script directly, bootstrapping Rails app"

  require_relative "lib/bootstrap"
  exit 0
end

source_paths.unshift(File.expand_path("source", __dir__))

directory "config"
directory "db"
directory "test"

inject_into_file "Gemfile", after: "group :development, :test do\n" do
  <<~RUBY.indent(2)
    gem "factory_bot_rails"
    gem "faker"

  RUBY
end

inject_into_class "test/test_helper.rb", "TestCase" do
  <<~RUBY.indent(4)
    include FactoryBot::Syntax::Methods

  RUBY
end

after_bundle do
  inject_into_file "app/models/application_record.rb", before: "end\n" do
    <<~RUBY.indent(2)

      before_create :generate_uuid_v7

      private

      def generate_uuid_v7
        self.id ||= SecureRandom.uuid_v7
      end
    RUBY
  end

  generate :authentication, "--skip"

  remove_dir "test/fixtures"
  rails_command "db:migrate"
end
