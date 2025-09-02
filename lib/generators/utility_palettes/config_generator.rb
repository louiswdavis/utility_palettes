# frozen_string_literal: true

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
