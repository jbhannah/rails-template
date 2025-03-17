require "pathname"

task :apply do
  Dir.chdir("example") do
    sh "bin/rails app:template LOCATION=../template.rb"
  end
end

task :clean do
  example = Pathname.new('example')
  example.rmtree if example.exist?

  %w[development test].each do |env|
    sh "dropdb example_#{env} --if-exists"
  end
end

task :example do
  sh "ruby bootstrap.rb example"
end

task default: %i[clean example]
