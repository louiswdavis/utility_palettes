# frozen_string_literal: true

module UtilityPalettes
  module Generators
    class ConfigGenerator < Rails::Generators::Base
      source_root File.expand_path('../../..', __dir__)

      def copy_config
        copy_file 'lib/generators/templates/config/utility_palettes.yml', 'config/utility_palettes.yml'
      end
    end
  end
end
