initializer "generators.rb" do
  <<~RUBY
    Rails.application.config.generators do |g|
      g.orm :active_record, primary_key_type: :uuid
    end
  RUBY
end

empty_directory ".vscode"

create_file ".vscode/launch.json" do
  <<~JSON
    {
      "version": "0.2.0",
      "configurations": [
        {
          "type": "ruby_lsp",
          "name": "Rails Server",
          "request": "launch",
          "program": "${workspaceFolder}/bin/rails s"
        },
        {
          "type": "ruby_lsp",
          "name": "Rails Console",
          "request": "launch",
          "program": "${workspaceFolder}/bin/rails c"
        }
      ]
    }
  JSON
end

inject_into_file "app/models/application_record.rb", before: %r{^end$} do
  <<~RUBY.indent(2)

    before_create :generate_uuid_v7

    private

    def generate_uuid_v7
      self.id ||= SecureRandom.uuid_v7
    end
  RUBY
end

inject_into_file "config/application.rb", before: %r{^  end$} do
  <<~RUBY.indent(4)

    config.active_record.encryption.key_provider = ActiveRecord::Encryption::EnvelopeEncryptionKeyProvider.new
  RUBY
end

inject_into_class "test/test_helper.rb", "TestCase" do
  <<~RUBY.indent(4)
    include FactoryBot::Syntax::Methods

  RUBY
end

inject_into_file "test/application_system_test_case.rb", before: %r{^end$} do
  <<~RUBY.indent(2)

    protected

    def sign_in(user)
      visit new_session_path
      fill_in :email_address, with: user.email_address
      fill_in :password, with: user.password
      click_button "Sign in"
      assert_selector "h1", text: "Tasks"
    end
  RUBY
end

gsub_file ".gitignore", "/config/master.key", "/config/**/*.key"

inject_into_file "Gemfile", after: "group :development, :test do\n" do
  <<~RUBY.indent(2)
    gem "factory_bot_rails"
    gem "faker"

  RUBY
end

after_bundle do
  rails_command "css:install:tailwind"

  generate :migration, "enable_pgcrypto_extension", "--skip"

  inject_into_file Pathname.glob("db/migrate/*_enable_pgcrypto_extension.rb").first, after: "def change\n" do
    <<~RUBY.indent(4)
      enable_extension :pgcrypto
    RUBY
  end

  generate :authentication, "--skip"

  inject_into_class "app/models/session.rb", "Session" do
    <<~RUBY.indent(2)
      encrypts :ip_address, :user_agent
    RUBY
  end

  inject_into_class "app/models/user.rb", "User" do
    <<~RUBY.indent(2)
      encrypts :email_address, deterministic: true
    RUBY
  end

  inject_into_class "test/models/user_test.rb", "UserTest" do
    <<~RUBY.indent(2)
      test "valid" do
        user = build(:user)
        assert user.valid?
      end
    RUBY
  end

  empty_directory "test/factories"

  create_file "test/factories/users.rb" do
    <<~RUBY
      FactoryBot.define do
        factory :user do
          email_address { Faker::Internet.email }
          password { Faker::Internet.password }
        end
      end
    RUBY
  end

  empty_directory "test/support/helpers"

  create_file "test/support/helpers/sign_in_helper.rb" do
    <<~RUBY
      module SignInHelper
        def sign_in(user)
          post session_path(email_address: user.email_address, password: user.password)
        end
      end
    RUBY
  end

  generate :controller, "root", "index", "--skip", "--skip-collision-check", "--skip-routes", "--skip-helper"

  inject_into_file "config/routes.rb", after: "root \"posts#index\"\n" do
    <<~RUBY.indent(2)
      root "root#index"
    RUBY
  end

  remove_dir "test/fixtures"
  rails_command "db:migrate"
end
