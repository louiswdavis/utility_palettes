# frozen_string_literal: true

require 'spec_helper'
require 'json'

RSpec.describe UtilityPalettes::Outputs do
  context 'methods' do
    it '.responds_to' do
      expect(described_class).to respond_to(:generate)
      expect(described_class).to respond_to(:json)
      expect(described_class).to respond_to(:scss)
      expect(described_class).to respond_to(:css)

      expect(described_class.new).to respond_to(:bespoke_property_variables)
    end

    before do
      @configuration = UtilityPalettes.configuration
      @generated_palettes = [['colour-50', ColorConverters::Color.new('#123456')]]

      @output_palettes = { 'colour-50' => '#123456', 'colour-100' => '#654321' }
    end

    it '.generate' do
      expect(described_class.generate(@generated_palettes)).to eq({ 'colour-50' => '#123456' })

      @configuration.output_format = 'rgb'
      expect(described_class.generate(@generated_palettes)).to eq({ 'colour-50' => 'rgb(18 52 86)' })

      @configuration.output_format = 'hsl'
      expect(described_class.generate(@generated_palettes)).to eq({ 'colour-50' => 'hsl(210.0 65.38% 20.39%)' })

      @configuration.output_format = 'hsv'
      expect(described_class.generate(@generated_palettes)).to eq({ 'colour-50' => 'hsv(210.0 79.07% 33.73%)' })

      @configuration.output_format = 'hsb'
      expect(described_class.generate(@generated_palettes)).to eq({ 'colour-50' => 'hsb(210.0 79.07% 33.73%)' })

      @configuration.output_format = 'cmyk'
      expect(described_class.generate(@generated_palettes)).to eq({ 'colour-50' => 'device-cmyk(79.07 39.53% 0.0% 66.27%)' })

      @configuration.output_format = 'cielab'
      expect(described_class.generate(@generated_palettes)).to eq({ 'colour-50' => 'lab(21.04% 1.05 -24.1)' })

      @configuration.output_format = 'cielch'
      expect(described_class.generate(@generated_palettes)).to eq({ 'colour-50' => 'lch(21.04% 24.12 272.5)' })

      @configuration.output_format = nil
      expect(described_class.generate([])).to eq({})
      expect(described_class.generate(@generated_palettes)).to eq({ 'colour-50' => 'rgb(18 52 86)' })
    end

    it '.json' do
      filepath = 'spec/tmp/outputs/test-json'
      result = described_class.json(filepath, @output_palettes)

      expect(result).to eq true
      expect(File.exist?("#{filepath}.json")).to be true
      file_content = JSON.parse(File.read("#{filepath}.json"))

      expect(file_content.length).to eq 2
      expect(file_content).to eq @output_palettes
    end

    it '.scss' do
      filepath = 'spec/tmp/outputs/test-scss'
      result = described_class.scss(filepath, @output_palettes)

      expect(result).to eq true
      expect(File.exist?("#{filepath}.scss")).to be true
      file_content = File.read("#{filepath}.scss").split("\n")

      expect(file_content.length).to eq 2
      expect(file_content).to eq(['$colour-50: #123456;', '$colour-100: #654321;'])
    end

    it '.css' do
      filepath = 'spec/tmp/outputs/test-css'
      result = described_class.css(filepath, @output_palettes)

      expect(result).to eq true
      expect(File.exist?("#{filepath}.css")).to be true
      file_content = File.read("#{filepath}.css").gsub("\t", '').split("\n")

      expect(file_content.length).to eq 4
      expect(file_content[0]).to eq ':root {'
      expect(file_content[1..2]).to eq ['--colour-50: #123456;', '--colour-100: #654321;']
      expect(file_content[3]).to eq '}'
    end
  end

  context 'private methods' do
    it '.responds_to' do
      expect(described_class).to respond_to(:append_percentage)
      expect(described_class).to respond_to(:append_alpha)
    end

    it '.append_percentage' do
      expect(described_class.append_percentage(0.0)).to eq '0.0%'
      expect(described_class.append_percentage(17.5)).to eq '17.5%'
      expect(described_class.append_percentage(100.0)).to eq '100.0%'
    end

    it '.append_alpha' do
      expect(described_class.append_alpha(0.0)).to eq '/ 0.0'
      expect(described_class.append_alpha(0.17)).to eq '/ 17.0'
      expect(described_class.append_alpha(1.0)).to eq '/ 100.0'
    end
  end
end
