# frozen_string_literal: true

module UtilityPalettes
  module Generators
    class GenerateGenerator < Rails::Generators::Base
      def generate_utility_palettes
        self.class.config_format_warn if File.exist?('config/utility_palettes.yml') || File.exist?('config/utility_palettes.json')

        if UtilityPalettes.configuration.enable_environments.include?(Rails.env.to_sym)
          UtilityPalettes::Palettes.generate
        else
          self.class.disabled_warn
        end
      end

      private

      # TODO: add links to README for migration
      def self.config_format_warn
        warn 'WARNING: Utility Palettes now uses an initializer to set config. You need to migrate and remove your YML/JSON file.'
      end

      # TODO: add links to README for environment setting
      def self.disabled_warn
        warn 'ERROR: Utility Palettes is disabled for this environment. Palettes will not be generated.'
      end
    end
  end
end
