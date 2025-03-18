#!/usr/bin/env ruby

require "pathname"

def options
  {
    css: "postcss",
    database: "postgresql",
    devcontainer: true,
    javascript: "bun",
  }
end

def bundle_rails(dir)
  gemfile = dir / "Gemfile"

  if gemfile.exist? and gemfile.read.include?('gem "rails"')
    puts "Gemfile already contains rails, skipping"
    return
  elsif gemfile.empty? or not gemfile.exist?
    gemfile.write('source "https://rubygems.org"')
    force = true
  end

  gemfile.write('gem "rails"')
  system(*%w[bundle install])

  return force
end

def help
  if (%w[-h --help] & ARGV).any?
    Pathname.mktmpdir do |dir|
      bundle_rails(dir)

      Dir.chdir(dir) do
        system(*%w[bundle exec rails new --help])
      end
    end

    exit 0
  end
end

def create_app_path
  if ARGV.empty? or ARGV[0].start_with?("-")
    puts "An app path or -h/--help is required as the first argument"
    exit 1
  end

  app_path_arg = ARGV.shift
  is_cwd = app_path_arg == "."

  app_path = Pathname.new(app_path_arg)

  unless is_cwd
    if app_path.exist? and not ((app_path.directory? and app_path.empty?) or (%w[-f --force] & ARGV).any?)
      puts "#{app_path} already exists and is not an empty directory, aborting"
      exit 1
    end

    app_path.mkdir unless app_path.exist?
  end

  return app_path, is_cwd
end

def set_ruby_version(dir)
  ruby_version_file = dir / Pathname(".ruby-version")
  ruby_version_file.write(RUBY_VERSION) unless ruby_version_file.exist?

  system("rbenv install --skip-existing #{RUBY_VERSION}")
end

def rails_new(dir, force, is_cwd)
  rails_new_command = %w[bundle exec rails new .]
  rails_new_command << "--force" if force

  options.each do |key, value|
    rails_new_command << "--#{key}=#{value}"
  end

  rails_new_command += ARGV

  if File.exist?("../template.rb")
    rails_new_command << "--template=../template.rb"
  else
    rails_new_command << "--template=https://raw.githubusercontent.com/jbhannah/rails-template/refs/heads/trunk/template.rb"
  end

  puts <<~EOF

    Creating Rails app in #{dir} with the following command:

        #{rails_new_command.join(" ")}

  EOF

  Dir.chdir(dir) do
    if system(*rails_new_command)
      puts <<~EOF

        Rails app created successfully#{" in #{dir}" unless is_cwd}!
        You can now#{" cd into it and" unless is_cwd} start it with:

            #{"cd #{dir}\n    " unless is_cwd}bin/dev
      EOF
    else
      exit $?.exitstatus
    end
  end
end

help
app_path, is_cwd = create_app_path
created_gemfile = bundle_rails(app_path)
rails_new(app_path, created_gemfile, is_cwd)
