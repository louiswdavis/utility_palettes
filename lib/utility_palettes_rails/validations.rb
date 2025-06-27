# frozen_string_literal: true

module UtilityPalettesRails
  class Validations
    def self.validate_config(config)
      sequence_options = ['hsl']
      warn "ERROR: The colour sequence method you have submitted to Utility Palettes < #{config[:steps]} > is not available (#{sequence_options.to_sentence})" if !config[:method].nil? && !config[:method].to_s.in?(sequence_options)

      warn "ERROR: The colour sequence steps you have submitted to Utility Palettes < #{config[:steps]} > have not been formatted as a hash" if !config[:steps].nil? && !config[:steps].is_a?(Hash)

      warn "ERROR: The absolute swatches you have submitted to Utility Palettes < #{config[:absolutes]} > have not been formatted as a hash" if !config[:absolutes].nil? && !config[:absolutes].is_a?(Hash)

      warn "ERROR: The relative swatches you have submitted to Utility Palettes < #{config[:relatives]} > have not been formatted as a hash" if !config[:relatives].nil? && !config[:relatives].is_a?(Hash)

      warn "ERROR: The single swatches you have submitted to Utility Palettes < #{config[:singles]} > have not been formatted as a hash" if !config[:singles].nil? && !config[:singles].is_a?(Hash)

      config_keys = config.keys - [:defaults, :output, :method, :steps, :absolutes, :relatives, :singles, :disabled]

      warn "WARNING: Utility Palettes does not recognize the following keys; #{config_keys.join(', ')}. Please check they match the spelling of documented palette keys in order for them to be used." if config_keys.present?

      true
    end
  end
end
