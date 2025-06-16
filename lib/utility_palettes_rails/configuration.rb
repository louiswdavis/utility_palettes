module UtilityPalettesRails
  class Configuration
    def self.setup(config)
      # default increment steps
      h_step = 2
      s_step = 2
      l_step = 9

      config_steps = config.dig(:steps)

      h_step = config_steps.dig(:h) if config_steps.dig(:h) != nil
      s_step = config_steps.dig(:s) if config_steps.dig(:s) != nil
      l_step = config_steps.dig(:l) if config_steps.dig(:l) != nil

      { h_step: h_step, s_step: s_step, l_step: l_step }
    end
  end
end
