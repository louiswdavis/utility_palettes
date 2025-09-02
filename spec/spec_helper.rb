# frozen_string_literal: true

require 'utility_palettes'
require 'color_converters'
require 'byebug'

ENV['RAILS_ENV'] ||= 'test'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:each) do
    UtilityPalettes.reset_configuration!

    UtilityPalettes.configure do |config|
      # Enabled Environments
      config.enable_environments = [:test]
    end
  end

  config.after(:each) do
    UtilityPalettes.reset_configuration!
  end
end
