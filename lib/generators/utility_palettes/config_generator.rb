# frozen_string_literal: true

begin
  require 'rails/generators'
  require 'rails/generators/base'
rescue LoadError => e
  raise LoadError, "railties gem is required for generators. Add 'railties' to your Gemfile: #{e.message}"
end

module UtilityPalettes
  module Generators
    class ConfigGenerator < Rails::Generators::Base
      source_root File.expand_path('../../..', __dir__)

      def copy_config
        copy_file 'lib/generators/templates/config/utility_palettes.rb', 'config/initializers/utility_palettes.rb'
      end
    end
  end
end
