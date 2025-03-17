require "pathname"

desc "Apply the template to the existing example app"
task :apply do
  Dir.chdir("example") do
    sh "bin/rails app:template LOCATION=../template.rb"
  end
end

desc "Remove the example app and its databases"
task :clean do
  example = Pathname.new('example')
  example.rmtree if example.exist?

  %w[development test].each do |env|
    sh "dropdb example_#{env} --if-exists"
  end
end

desc "Clean and bootstrap the example app"
task example: :clean do
  sh "ruby bootstrap.rb example"
end

desc "Without arguments, clean and bootstrap the example app"
task default: :example
