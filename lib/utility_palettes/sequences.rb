# frozen_string_literal: true

require 'color_converters'
require 'bigdecimal'

# an increase in the 'level' makes the percieved colour darker

module UtilityPalettes
  class Sequences
    def self.hsl(colour, level_change)
      colour_hsl = colour.hsl
      configuration = UtilityPalettes.configuration

      # Use BigDecimal for precise decimal arithmetic
      h_value = (BigDecimal(colour_hsl[:h].to_s) - BigDecimal((level_change * configuration.steps_h).to_s)) % 360
      s_value = (BigDecimal(colour_hsl[:s].to_s) - BigDecimal((level_change * configuration.steps_s).to_s)).clamp(0, 100)
      l_value = (BigDecimal(colour_hsl[:l].to_s) - BigDecimal((level_change * configuration.steps_l).to_s)).clamp(0, 100)

      ColorConverters::Color.new(h: h_value.to_f, s: s_value.to_f, l: l_value.to_f)
    end

    def self.rgb(colour, level_change)
      colour_rgb = colour.rgb
      configuration = UtilityPalettes.configuration

      # Use BigDecimal for precise decimal arithmetic
      r_value = (BigDecimal(colour_rgb[:r].to_s) - BigDecimal((level_change * configuration.steps_r).to_s)).clamp(0, 255)
      g_value = (BigDecimal(colour_rgb[:g].to_s) - BigDecimal((level_change * configuration.steps_g).to_s)).clamp(0, 255)
      b_value = (BigDecimal(colour_rgb[:b].to_s) - BigDecimal((level_change * configuration.steps_b).to_s)).clamp(0, 255)

      ColorConverters::Color.new(r: r_value.to_f, g: g_value.to_f, b: b_value.to_f)
    end

    # def tailwind(_colour, _step, _go_lighter, _increment_steppers)
    #   # def pSBC(p, _c0, _c1, l)
    #   #   r = nil
    #   #   g = nil
    #   #   b = nil
    #   #   pP = nil
    #   #   f = nil
    #   #   t = nil

    #   #   if l
    #   #     pPr = pP * f[:r]
    #   #     f[:g]
    #   #     pPb = pP * f[:b]

    #   #     ptr = p * t[:r]
    #   #     t[:g]
    #   #     ptb = p * t[:b]

    #   #     r = (pPr + ptr).round
    #   #     g = (pPb + ptb).round
    #   #     b = (pPb + ptb).round
    #   # else
    #   #   pPr = pP * (f[:r]**2)
    #   #   pPg = pP * (f[:g]**2)
    #   #   pPb = pP * (f[:b]**2)

    #   #   ptr = p * (t[:r]**2)
    #   #   ptg = p * (t[:g]**2)
    #   #   ptb = p * (t[:b]**2)

    #   #   r = ((pPr + ptr)**0.5).round
    #   #   g = ((pPg + ptg)**0.5).round
    #   #   b = ((pPb + ptb)**0.5).round
    #   # end

    #   # a = f.a
    #   # t = t.a
    #   # f = a >= 0 || t >= 0

    #   # t if f && a.negative?

    #   # a = if f
    #   #       if a.negative?
    #   #         t
    #   #       else
    #   #         t.negative? ? a : a * pP + t * p
    #   #       end
    #   #     else
    #   #       0
    #   #     end

    #   ColorConverters::Color.new(r: r, g: g, b: b, a: m(a * 1000) / 1000)
    # end
  end
end
