#!/usr/bin/env ruby

if caller.empty?
  puts "Running script directly, bootstrapping Rails app"

  require_relative "lib/bootstrap"
  exit 0
end

after_bundle do
  generate :migration, "enable_pgcrypto_extension", "--skip"
  pgcrypto_migration_file = Dir.glob("db/migrate/*_enable_pgcrypto_extension.rb").first

  insert_into_file pgcrypto_migration_file, after: "  def change\n" do
    <<~RUBY.indent(4)
      enable_extension :pgcrypto
    RUBY
  end

  initializer "generators.rb", <<~RUBY
    Rails.application.config.generators do |g|
      g.orm :active_record, primary_key_type: :uuid
    end
  RUBY

  inject_into_file "app/models/application_record.rb", before: "end\n" do
    <<~RUBY.indent(2)

      before_create :generate_uuid_v7

      private

      def generate_uuid_v7
        self.id ||= SecureRandom.uuid_v7
      end
    RUBY
  end

  rails_command "db:migrate"
end
