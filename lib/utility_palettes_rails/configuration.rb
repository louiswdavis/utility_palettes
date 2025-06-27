# frozen_string_literal: true

module UtilityPalettesRails
  class Configuration
    def self.setup(config)
      # default increment steps
      default_increments = UtilityPalettesRails::Configuration.defaults

      user_increments = config.dig(:steps) || {}

      h_step = user_increments.dig(:h) || default_increments.dig('hsl', :h)
      s_step = user_increments.dig(:s) || default_increments.dig('hsl', :s)
      l_step = user_increments.dig(:l) || default_increments.dig('hsl', :l)

      { h_step: h_step, s_step: s_step, l_step: l_step }
    end

    def self.defaults
      {
        'rgb' => { r: '7%', g: '7%', b: '7%' },
        'hsl' => { h: 0, s: 2, l: 9 }
      }
    end
  end
end
