source_path = File.expand_path("source", __dir__)
source_paths.unshift(source_path)

Pathname.new(source_path).children.select(&:directory?).each do |dir|
  directory "#{dir.basename}"
end

inject_into_file "app/models/application_record.rb", before: "end\n" do
  <<~RUBY.indent(2)

    before_create :generate_uuid_v7

    private

    def generate_uuid_v7
      self.id ||= SecureRandom.uuid_v7
    end
  RUBY
end

append_to_file "config/puma.rb" do
  <<~RUBY

    # Enable the Tailwind CSS plugin for Puma in development
    plugin :tailwindcss if ENV.fetch("RAILS_ENV", "development") == "development"
  RUBY
end

inject_into_class "test/test_helper.rb", "TestCase" do
  <<~RUBY.indent(4)
    include FactoryBot::Syntax::Methods

  RUBY
end

inject_into_file "Gemfile", after: "group :development, :test do\n" do
  <<~RUBY.indent(2)
    gem "factory_bot_rails"
    gem "faker"

  RUBY
end

after_bundle do
  generate :authentication, "--skip"

  remove_dir "test/fixtures"
  rails_command "db:migrate"
end
