# frozen_string_literal: true

require 'rails/generators'

require_relative '../../lib/generators/utility_palettes/config_generator'

RSpec.describe UtilityPalettes::Generators::ConfigGenerator, type: :generator do
  destination File.expand_path('../tmp', __dir__)

  before do
    prepare_destination
  end

  it 'creates a config template' do
    run_generator

    assert_file 'config/initializers/utility_palettes.rb'
  end
end
