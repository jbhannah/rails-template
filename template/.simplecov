# frozen_string_literal: true

SimpleCov.start 'rails' do
  add_group 'Actors', 'app/actors'

  enable_coverage :branch

  if ENV['CI']
    require 'simplecov-cobertura'

    formatter SimpleCov::Formatter::CoberturaFormatter
  end
end
