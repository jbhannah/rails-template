require_relative "helpers"

options = {
  css: "tailwind",
  database: "postgresql",
  devcontainer: true,
}

if (%w[-h --help] & ARGV).any?
  require "tmpdir"

  Dir.mktmpdir do |dir|
    Dir.chdir(dir) do
      install_rails
      system(*%w[bundle exec rails new --help])
    end
  end

  exit 0
end

if ARGV.empty? or ARGV[0].start_with?("-")
  puts "An app path or -h/--help is required as the first argument"
  exit 1
end

app_path = ARGV.shift

if app_path != "."
  if File.exist?(app_path) and not (Dir.empty?(app_path) or (%w[-f --force] & ARGV).any?)
    puts "#{app_path} already exists and is not an empty directory, aborting"
    exit 1
  end

  Dir.mkdir(app_path) unless Dir.exist?(app_path)
  Dir.chdir(app_path)
end

created_gemfile = install_rails

rails_new_command = %w[bundle exec rails new .]
rails_new_command << "--force" if created_gemfile

options.each do |key, value|
  rails_new_command << "--#{key}=#{value}"
end

rails_new_command += ARGV

if File.exist?("../template.rb")
  rails_new_command << "--template=../template.rb"
else
  rails_new_command << "--template=https://raw.githubusercontent.com/jbhannah/rails-template/HEAD/template.rb"
end

puts <<~EOF

  Creating Rails app in #{app_path} with the following command:

      #{rails_new_command.join(" ")}

EOF

if system(*rails_new_command)
  puts <<~EOF

    Rails app created successfully#{" in #{app_path}" if app_path != "."}!
    You can now#{" cd into it and" if app_path != "."} start it with:

        #{"cd #{app_path}\n    " if app_path != "."}bin/rails server
  EOF
else
  exit $?.exitstatus
end
