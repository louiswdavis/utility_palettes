# frozen_string_literal: true

require 'spec_helper'

RSpec.describe UtilityPalettes::Sequences do
  context 'methods' do
    it '.hsl' do
      colour = ColorConverters::Color.new(h: 27, s: 34, l: 48)
      increment_steppers = { h_step: 3, s_step: 12, l_step: 6 }

      expect(described_class.hsl(colour, 2, increment_steppers)).to eq ColorConverters::Color.new(h: 21.0, s: 10.0, l: 36.0)
      expect(described_class.hsl(colour, -3, increment_steppers)).to eq ColorConverters::Color.new(h: 36.0, s: 70.0, l: 66.0)
    end

    it '.rgb' do
      colour = ColorConverters::Color.new(r: 127, g: 34, b: 148)
      increment_steppers = { r_step: 23, g_step: 12, b_step: 16 }

      expect(described_class.rgb(colour, 2, increment_steppers)).to eq ColorConverters::Color.new(r: 81.0, g: 10.0, b: 116.0)
      expect(described_class.rgb(colour, -3, increment_steppers)).to eq ColorConverters::Color.new(r: 196.0, g: 70.0, b: 196.0)

      increment_steppers = { rgb_step: 44 }

      expect(described_class.rgb(colour, 4, increment_steppers)).to eq ColorConverters::Color.new(r: 0.0, g: 0.0, b: 0.0)
      expect(described_class.rgb(colour, -2, increment_steppers)).to eq ColorConverters::Color.new(r: 215.0, g: 122.0, b: 236.0)
      expect(described_class.rgb(colour, -6, increment_steppers)).to eq ColorConverters::Color.new(r: 255.0, g: 255.0, b: 255.0)
    end
  end
end
