# frozen_string_literal: true

require 'spec_helper'

RSpec.describe UtilityPalettes::Sequences do
  context 'methods' do
    it '.responds_to' do
      expect(described_class).to respond_to(:hsl)
      expect(described_class).to respond_to(:rgb)
    end

    before do
      @configuration = UtilityPalettes.configuration
    end

    it '.hsl' do
      @configuration.steps_h = 3
      @configuration.steps_s = -12
      @configuration.steps_l = 6

      colour = ColorConverters::Color.new(h: 27, s: 34, l: 48)
      expect(described_class.hsl(colour, -3)).to eq ColorConverters::Color.new(h: 36.0, s: 0.0, l: 66.0) # negative counter => increase H & L, decrease S
      expect(described_class.hsl(colour, 2)).to eq ColorConverters::Color.new(h: 21.0, s: 58.0, l: 36.0) # negative counter => increase H & L, decrease S
    end

    it '.rgb' do
      @configuration.steps_r = 23
      @configuration.steps_g = 12
      @configuration.steps_b = 16

      colour = ColorConverters::Color.new(r: 127, g: 34, b: 148)
      expect(described_class.rgb(colour, -3)).to eq ColorConverters::Color.new(r: 196.0, g: 70.0, b: 196.0) # negative counter => increase H & L, decrease S
      expect(described_class.rgb(colour, 2)).to eq ColorConverters::Color.new(r: 81.0, g: 10.0, b: 116.0) # negative counter => increase H & L, decrease S
    end
  end
end
