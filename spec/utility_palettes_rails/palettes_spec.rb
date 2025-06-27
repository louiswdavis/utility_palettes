# frozen_string_literal: true

require 'spec_helper'

RSpec.describe UtilityPalettesRails::Palettes do
  context 'methods' do
    it 'generate' do
      expect(described_class.generate({})).to eq true
    end
  end

  context 'private methods' do
    it 'colourize_values' do
      expect(described_class.colourize_values({})).to eq({})
    end

    it 'palette_looper' do
      expect(described_class.palette_looper({}, 'absolutes')).to eq({})
      expect(described_class.palette_looper({}, 'relatives')).to eq({})
    end

    it 'format_palette' do
      expect(described_class.format_palette({})).to eq({})
    end
  end
end
