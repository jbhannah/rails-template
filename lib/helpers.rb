def install_rails
  gemfile = ['gem "rails"']

  if not File.exist?("Gemfile")
    gemfile.unshift('source "https://rubygems.org"')
    created_gemfile = true
  elsif File.readlines("Gemfile").any?(/gem "rails"/)
    puts "Gemfile already contains rails, skipping"
    skipped_gemfile = true
  end

  puts <<~EOF

    Writing the following to Gemfile and running bundle install:

    #{gemfile.map { |line| "    " + line }.join("\n")}

  EOF

  File.open("Gemfile", "a") do |f|
    f.write gemfile.join("\n")
  end unless skipped_gemfile

  system(*%w[bundle install])

  return created_gemfile
end
