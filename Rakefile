require "pathname"

example = Pathname.new('example')

desc "Apply the template to the existing example app"
task :apply do
  Dir.chdir("example") do
    sh "bin/rails app:template LOCATION=../template.rb"
  end
end

desc "Remove the example app and its databases"
task :clean do
  example.rmtree if example.exist?

  %w[development test].each do |env|
    sh "dropdb example_#{env} --if-exists"
  end
end

desc "Bootstrap the app in an empty directory"
task cd: :clean do
  example.mkdir

  Dir.chdir(example) do
    sh "ruby ../bootstrap.rb ."
  end
end

desc "Clean and bootstrap the example app"
task example: :clean do
  sh "ruby bootstrap.rb example"
end

desc "Without arguments, clean and bootstrap the example app"
task default: :example
