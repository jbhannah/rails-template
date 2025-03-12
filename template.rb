#!/usr/bin/env ruby

if caller.empty?
  puts "Running script directly, bootstrapping Rails app"

  require_relative "lib/bootstrap"
  exit 0
end

after_bundle do
  rails_command "db:migrate"
end
