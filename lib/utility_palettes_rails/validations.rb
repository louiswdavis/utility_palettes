module UtilityPalettesRails
  class Validations
    def self.validate_config(config)
      if config.dig(:method) != nil && !config.dig(:method).to_s.in?(['hsl'])
        STDERR.puts "ERROR: The colour sequence method you have submitted to Utility Palettes < #{config.dig(:steps)} > is not available ('hsl')"
      end

      if config.dig(:steps) != nil && !config.dig(:steps).is_a?(Hash)
        STDERR.puts "ERROR: The colour sequence steps you have submitted to Utility Palettes < #{config.dig(:steps)} > have not been formatted as a map"
      end
    
      if config.dig(:absolutes) != nil && !config.dig(:absolutes).is_a?(Hash)
        STDERR.puts "ERROR: The absolute swatches you have submitted to Utility Palettes < #{config.dig(:absolutes)} > have not been formatted as a map"
      end
    
      if config.dig(:relatives) != nil && !config.dig(:relatives).is_a?(Hash)
        STDERR.puts "ERROR: The relative swatches you have submitted to Utility Palettes < #{config.dig(:relatives)} > have not been formatted as a map"
      end
    
      if config.dig(:singles) != nil && !config.dig(:singles).is_a?(Hash)
        STDERR.puts "ERROR: The single swatches you have submitted to Utility Palettes < #{config.dig(:singles)} > have not been formatted as a map"
      end

      config_keys = config.keys - [:defaults, :output, :method, :steps, :absolutes, :relatives, :singles]
    
      if config_keys.present?
        STDERR.puts "WARNING: Utility Palettes does not recognize the following keys; #{config_keys.join(', ')}. Please check they match the spelling of documented palette keys in order for them to be used."
      end
    end
  end
end