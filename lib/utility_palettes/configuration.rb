# frozen_string_literal: true

module UtilityPalettes
  class Configuration
    attr_accessor :enable_environments,
                  :use_default_absolutes, :use_default_relatives, :use_default_singles,
                  :output_dated, :output_files, :output_format, :output_prefix, :output_suffix,
                  :method, :steps_h, :steps_s, :steps_l, :steps_r, :steps_g, :steps_b,
                  :absolutes, :relatives, :singles

    def initialize
      # Enabled Environments
      @enable_environments = [:development]

      # Defaults
      @use_default_absolutes = true
      @use_default_relatives = true
      @use_default_singles = true

      # Output
      @output_dated = false
      @output_files = ['json']
      @output_format = 'hex'
      @output_prefix = ''
      @output_suffix = ''

      # Method
      @method = 'hsl'

      # Steps
      @steps_h = 0
      @steps_s = 3
      @steps_l = 8
      @steps_r = 9
      @steps_g = 9
      @steps_b = 9

      # Colors - Absolutes
      @absolutes = {}

      # Colors - Relatives
      @relatives = {}

      # Colors - Singles
      @singles = {}
    end

    def reset!
      self.initialize
    end

    def validate_settings
      warn "ERROR: The colour sequence method you have submitted to Utility Palettes < #{@method} > is not available" unless @method.to_s.in?(['hsl'])

      # warn "ERROR: The colour sequence steps you have submitted to Utility Palettes < #{@steps} > have not been formatted as a hash" unless @steps.is_a?(Hash)

      warn "ERROR: The output files you have submitted to Utility Palettes < #{@output_files} > have not been formatted as an array" unless @absolutes.is_a?(Array)

      warn "ERROR: The absolute swatches you have submitted to Utility Palettes < #{@absolutes} > have not been formatted as a hash" unless @absolutes.is_a?(Hash)
      warn "ERROR: The relative swatches you have submitted to Utility Palettes < #{@relatives} > have not been formatted as a hash" unless @relatives.is_a?(Hash)
      warn "ERROR: The single swatches you have submitted to Utility Palettes < #{@singles} > have not been formatted as a hash" unless @singles.is_a?(Hash)

      [@method.to_s.in?(['hsl']), @absolutes.is_a?(Hash), @relatives.is_a?(Hash), @singles.is_a?(Hash)].all?
    end
  end

  class << self
    attr_writer :configuration

    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end

    def reset_configuration!
      @configuration = Configuration.new
    end
  end
end
