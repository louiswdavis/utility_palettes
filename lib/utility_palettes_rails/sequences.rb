require 'color_conversion'

module UtilityPalettesRails
  class Sequences
    def self.hsl(colour, step, go_lighter, sequence_steps)
      h_step = sequence_steps[:h_step]
      s_step = sequence_steps[:s_step]
      l_step = sequence_steps[:l_step]

      h_value = colour.hsl[:h]
      s_value = colour.hsl[:s]
      l_value = colour.hsl[:l]

      if go_lighter
        h_value = colour.hsl[:h] + (step * h_step)
        s_value = [colour.hsl[:s] - (step * s_step), 0].max
        l_value = [colour.hsl[:l] + (step * l_step), 100].min

        h_value - 360 if h_value > 360
      else
        h_value = colour.hsl[:h] - (step * h_step)
        s_value = [colour.hsl[:s] + (step * s_step), 100].min
        l_value = [colour.hsl[:l] - (step * l_step), 0].max

        h_value + 360 if h_value < 0
      end

      ColorConversion::Color.new(h: h_value, s: s_value, l: l_value)
    end
  end
end