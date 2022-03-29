# frozen_string_literal: true

require 'faraday'
require 'faraday/my_adapter'
# This is the magic bit. It requires a tests suite from the Faraday gem that you can run against your adapter
require 'faraday_specs_setup'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.order = :random
end
