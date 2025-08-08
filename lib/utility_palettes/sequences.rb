# frozen_string_literal: true

require 'color_converters'
require 'bigdecimal'

# an increase in the 'level' makes the percieved colour darker

module UtilityPalettes
  class Sequences
    def self.hsl(colour, level_change, increment_steppers)
      h_step = increment_steppers[:h_step]
      s_step = increment_steppers[:s_step]
      l_step = increment_steppers[:l_step]

      # Use BigDecimal for precise decimal arithmetic
      h_value = (BigDecimal(colour.hsl[:h].to_s) - BigDecimal((level_change * h_step).to_s)) % 360
      s_value = (BigDecimal(colour.hsl[:s].to_s) - BigDecimal((level_change * s_step).to_s)).clamp(0, 100)
      l_value = (BigDecimal(colour.hsl[:l].to_s) - BigDecimal((level_change * l_step).to_s)).clamp(0, 100)

      ColorConverters::Color.new(h: h_value.to_f, s: s_value.to_f, l: l_value.to_f)
    end

    def self.rgb(colour, level_change, increment_steppers)
      r_step = increment_steppers[:r_step] || increment_steppers[:rgb_step]
      g_step = increment_steppers[:g_step] || increment_steppers[:rgb_step]
      b_step = increment_steppers[:b_step] || increment_steppers[:rgb_step]

      # Use BigDecimal for precise decimal arithmetic
      r_value = (BigDecimal(colour.rgb[:r].to_s) - BigDecimal((level_change * r_step).to_s)).clamp(0, 255).to_f
      g_value = (BigDecimal(colour.rgb[:g].to_s) - BigDecimal((level_change * g_step).to_s)).clamp(0, 255).to_f
      b_value = (BigDecimal(colour.rgb[:b].to_s) - BigDecimal((level_change * b_step).to_s)).clamp(0, 255).to_f

      ColorConverters::Color.new(r: r_value, g: g_value, b: b_value)
    end

    def tailwind(_colour, _step, _go_lighter, _increment_steppers)
      # def pSBC(p, _c0, _c1, l)
      #   r = nil
      #   g = nil
      #   b = nil
      #   pP = nil
      #   f = nil
      #   t = nil

      #   if l
      #     pPr = pP * f[:r]
      #     f[:g]
      #     pPb = pP * f[:b]

      #     ptr = p * t[:r]
      #     t[:g]
      #     ptb = p * t[:b]

      #     r = (pPr + ptr).round
      #     g = (pPb + ptb).round
      #     b = (pPb + ptb).round
      # else
      #   pPr = pP * (f[:r]**2)
      #   pPg = pP * (f[:g]**2)
      #   pPb = pP * (f[:b]**2)

      #   ptr = p * (t[:r]**2)
      #   ptg = p * (t[:g]**2)
      #   ptb = p * (t[:b]**2)

      #   r = ((pPr + ptr)**0.5).round
      #   g = ((pPg + ptg)**0.5).round
      #   b = ((pPb + ptb)**0.5).round
      # end

      # a = f.a
      # t = t.a
      # f = a >= 0 || t >= 0

      # t if f && a.negative?

      # a = if f
      #       if a.negative?
      #         t
      #       else
      #         t.negative? ? a : a * pP + t * p
      #       end
      #     else
      #       0
      #     end

      ColorConverters::Color.new(r: r, g: g, b: b, a: m(a * 1000) / 1000)
    end
  end
end
