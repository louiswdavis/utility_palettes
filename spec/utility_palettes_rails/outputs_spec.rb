# frozen_string_literal: true

require 'spec_helper'
require 'json'

RSpec.describe UtilityPalettesRails::Outputs do
  context 'methods' do
    before do
      @generated_palettes = [['colour-50', ColorConverters::Color.new('#123456')]]

      @output_palettes = { 'colour-50' => '#123456', 'colour-100' => '#654321' }
    end

    it 'generate' do
      expect(described_class.generate(@generated_palettes, { output: { format: 'rgb' } })).to eq({ 'colour-50' => 'rgb(18 52 86)' })
      expect(described_class.generate(@generated_palettes, { output: { format: 'hsl' } })).to eq({ 'colour-50' => 'hsl(210.0 65.38% 20.39%)' })
      expect(described_class.generate(@generated_palettes, { output: { format: 'hsv' } })).to eq({ 'colour-50' => 'hsv(210.0 79.07% 33.73%)' })
      expect(described_class.generate(@generated_palettes, { output: { format: 'hsb' } })).to eq({ 'colour-50' => 'hsb(210.0 79.07% 33.73%)' })
      expect(described_class.generate(@generated_palettes, { output: { format: 'cmyk' } })).to eq({ 'colour-50' => 'device-cmyk(79.07 39.53% 0.0% 66.27%)' })
      expect(described_class.generate(@generated_palettes, { output: { format: 'cielab' } })).to eq({ 'colour-50' => 'lab(21.04% 1.05 -24.1)' })
      expect(described_class.generate(@generated_palettes, { output: { format: 'cielch' } })).to eq({ 'colour-50' => 'lch(21.04% 24.12 272.5)' })
      expect(described_class.generate(@generated_palettes, { output: { format: 'hex' } })).to eq({ 'colour-50' => '#123456' })
      expect(described_class.generate(@generated_palettes, {})).to eq({ 'colour-50' => 'rgb(18 52 86)' })
      expect(described_class.generate([], {})).to eq({})
    end

    it 'json' do
      file = described_class.json('test-json', @output_palettes)
      open_file = JSON.parse(file.read)
      expect(open_file.length).to eq 2
      expect(open_file).to eq @output_palettes
    end

    it 'scss' do
      file = described_class.scss('test-scss', @output_palettes)
      open_file = file.read.split("\n")
      expect(open_file.length).to eq 2
      expect(open_file).to eq ['$colour-50: #123456;', '$colour-100: #654321;']
    end

    it 'css' do
      file = described_class.css('test-css', @output_palettes)
      open_file = file.read.gsub("\t", '').split("\n")
      expect(open_file.length).to eq 4
      expect(open_file.first).to eq ':root {'
      expect(open_file[1..2]).to eq ['--colour-50: #123456;', '--colour-100: #654321;']
      expect(open_file.last).to eq '}'
    end
  end

  context 'private methods' do
    it 'append_percentage' do
      expect(described_class.append_percentage(0.0)).to eq '0.0%'
      expect(described_class.append_percentage(17.5)).to eq '17.5%'
      expect(described_class.append_percentage(100.0)).to eq '100.0%'
    end

    it 'append_alpha' do
      expect(described_class.append_alpha(0.0)).to eq '/ 0.0'
      expect(described_class.append_alpha(0.17)).to eq '/ 17.0'
      expect(described_class.append_alpha(1.0)).to eq '/ 100.0'
    end
  end
end
