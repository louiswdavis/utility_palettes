# frozen_string_literal: true

module UtilityPalettes
  module Generators
    class GenerateGenerator < Rails::Generators::Base
      def generate_utility_palettes
        config = {}

        if File.exist?('config/utility_palettes.yml') && defined?(Rails.application.config_for)
          config = Rails.application.config_for(:utility_palettes).dig('utility_palettes')
        elsif File.exist?('config/utility_palettes.json')
          config = JSON.parse(File.read('config/utility_palettes.json')).dig(Rails.env.to_s, 'utility_palettes')
        end

        if !config.is_a?(Hash)
          self.class.config_format_warn
        elsif config.dig('disabled') == true
          self.class.disabled_warn
        else
          UtilityPalettes::Palettes.generate(config)
        end
      end

      private

      def self.config_format_warn
        warn 'ERROR: Utility Palettes config is not formatted as a hash for the "utility_palettes" value'
      end

      def self.disabled_warn
        warn 'ERROR: Utility Palettes is disabled for this environment'
      end
    end
  end
end
