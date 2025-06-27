# frozen_string_literal: true

require 'spec_helper'

RSpec.describe UtilityPalettesRails::Swatch do
  context 'methods' do
    it '.absolute_generator' do
      colour = ColorConverters::Color.new(h: 27, s: 34, l: 48)
      increment_steppers = { h_step: 3, s_step: -12, l_step: 6 }
      expect(described_class.absolute_generator('test', colour, 'hsl', increment_steppers)).to eq(
        {
          'test-50' => ColorConverters::Color.new(h: 42.0, s: 0.0, l: 78.0),
          'test-100' => ColorConverters::Color.new(h: 39.0, s: 0.0, l: 72.0),
          'test-200' => ColorConverters::Color.new(h: 36.0, s: 0.0, l: 66.0),
          'test-300' => ColorConverters::Color.new(h: 33.0, s: 10.0, l: 60.0),
          'test-400' => ColorConverters::Color.new(h: 30.0, s: 22.0, l: 54.0),
          'test-500' => ColorConverters::Color.new(h: 27.0, s: 34.0, l: 48.0),
          'test-600' => ColorConverters::Color.new(h: 24.0, s: 46.0, l: 42.0),
          'test-700' => ColorConverters::Color.new(h: 21.0, s: 58.0, l: 36.0),
          'test-800' => ColorConverters::Color.new(h: 18.0, s: 70.0, l: 30.0),
          'test-900' => ColorConverters::Color.new(h: 15.0, s: 82.0, l: 24.0)
        }
      )

      colour = ColorConverters::Color.new(h: 310, s: 29, l: 9)
      increment_steppers = { h_step: 30, s_step: -4, l_step: 11 }
      expect(described_class.absolute_generator('other', colour, 'hsl', increment_steppers)).to eq(
        {
          'other-50' => ColorConverters::Color.new(h: 220.0, s: 0.0, l: 100.0),
          'other-100' => ColorConverters::Color.new(h: 190.0, s: 0.0, l: 97.0),
          'other-200' => ColorConverters::Color.new(h: 160.0, s: 1.02, l: 86.0),
          'other-300' => ColorConverters::Color.new(h: 130.0, s: 5.02, l: 75.0),
          'other-400' => ColorConverters::Color.new(h: 100.0, s: 9.02, l: 64.0),
          'other-500' => ColorConverters::Color.new(h: 70.0, s: 13.02, l: 53.0),
          'other-600' => ColorConverters::Color.new(h: 40.0, s: 17.02, l: 42.0),
          'other-700' => ColorConverters::Color.new(h: 10.0, s: 21.02, l: 31.0),
          'other-800' => ColorConverters::Color.new(h: 340.0, s: 25.02, l: 20.0),
          'other-900' => ColorConverters::Color.new(h: 310.0, s: 29.02, l: 9.0)
        }
      )
    end

    it '.relative_generator' do
      colour = ColorConverters::Color.new(h: 27, s: 34, l: 48)
      increment_steppers = { h_step: 15, s_step: 22, l_step: -23 }
      expect(described_class.relative_generator('test', colour, 'hsl', increment_steppers)).to eq(
        {
          'test-dark' => ColorConverters::Color.new(h: 57.0, s: 78.0, l: 2.0),
          'test' => ColorConverters::Color.new(h: 27.0, s: 34.0, l: 48.0),
          'test-light' => ColorConverters::Color.new(h: 357.0, s: 0.0, l: 94.0)
        }
      )

      colour = ColorConverters::Color.new(h: 310, s: 68, l: 87)
      increment_steppers = { h_step: -30, s_step: -24, l_step: 11 }
      expect(described_class.relative_generator('other', colour, 'hsl', increment_steppers)).to eq(
        {
          'other-dark' => ColorConverters::Color.new(h: 250.0, s: 19.99, l: 100.0),
          'other' => ColorConverters::Color.new(h: 310.0, s: 68.0, l: 87.0),
          'other-light' => ColorConverters::Color.new(h: 340.0, s: 91.99, l: 76.0)
        }
      )
    end

    it '.base_lightness_index' do
      expect(described_class.base_lightness_index(ColorConverters::Color.new(h: 50, s: 50, l: 0))).to eq 9
      expect(described_class.base_lightness_index(ColorConverters::Color.new(h: 50, s: 50, l: 8))).to eq 9
      expect(described_class.base_lightness_index(ColorConverters::Color.new(h: 50, s: 50, l: 18))).to eq 8
      expect(described_class.base_lightness_index(ColorConverters::Color.new(h: 50, s: 50, l: 25))).to eq 7
      expect(described_class.base_lightness_index(ColorConverters::Color.new(h: 50, s: 50, l: 44))).to eq 5
      expect(described_class.base_lightness_index(ColorConverters::Color.new(h: 50, s: 50, l: 100))).to eq(-1)
    end

    it '.label' do
      expect(described_class.label('primary', 0)).to eq 'primary-50'
      expect(described_class.label('secondary', 4)).to eq 'secondary-400'
      expect(described_class.label('red', 9)).to eq 'red-900'
      expect(described_class.label('blue', 10)).to eq 'blue-'
    end

    it '.generate' do
      colour = ColorConverters::Color.new(h: 27, s: 34, l: 48)
      # increment_steps are based on the last time they are set in the above specs (-30, -24, 11)
      expect(described_class.generate(colour, 2, 4)).to eq ColorConverters::Color.new(h: 87.0, s: 82.0, l: 26.0)
      expect(described_class.generate(colour, 6, 3)).to eq ColorConverters::Color.new(h: 297.0, s: 0.0, l: 81.0)
    end
  end
end
