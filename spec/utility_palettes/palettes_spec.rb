# frozen_string_literal: true

RSpec.describe UtilityPalettes::Palettes do
  context 'methods' do
    it '.responds_to' do
      expect(described_class).to respond_to(:generate)
    end

    it '.generate' do
      allow(UtilityPalettes).to receive(:configuration).and_call_original

      allow(UtilityPalettes::Defaults).to receive(:absolutes).and_call_original
      allow(UtilityPalettes::Defaults).to receive(:relatives).and_call_original
      allow(UtilityPalettes::Defaults).to receive(:singles).and_call_original

      allow(UtilityPalettes::Palettes).to receive(:colourize_values).and_call_original
      allow(UtilityPalettes::Palettes).to receive(:palette_looper).and_call_original

      allow(UtilityPalettes::Swatch).to receive(:absolute_generator).and_call_original
      allow(UtilityPalettes::Swatch).to receive(:relative_generator).and_call_original
      allow(UtilityPalettes::Swatch).to receive(:generate).and_call_original

      allow(UtilityPalettes::Sequences).to receive(:hsl).and_call_original
      allow(UtilityPalettes::Sequences).to receive(:rgb).and_call_original

      allow(UtilityPalettes::Outputs).to receive(:generate).and_call_original
      allow(UtilityPalettes::Outputs).to receive(:json).and_call_original
      allow(UtilityPalettes::Outputs).to receive(:scss).and_call_original
      allow(UtilityPalettes::Outputs).to receive(:css).and_call_original

      expect(described_class.generate).to eq true

      expect(UtilityPalettes).to have_received(:configuration).exactly(224).times

      expect(UtilityPalettes::Defaults).to have_received(:absolutes).exactly(1).times
      expect(UtilityPalettes::Defaults).to have_received(:relatives).exactly(1).times
      expect(UtilityPalettes::Defaults).to have_received(:singles).exactly(1).times

      expect(UtilityPalettes::Palettes).to have_received(:colourize_values).exactly(3).times
      expect(UtilityPalettes::Palettes).to have_received(:palette_looper).exactly(2).times

      expect(UtilityPalettes::Swatch).to have_received(:absolute_generator).exactly(19).times # UtilityPalettes::Defaults.absolutes.length
      expect(UtilityPalettes::Swatch).to have_received(:relative_generator).exactly(4).times # UtilityPalettes::Defaults.relatives.length
      expect(UtilityPalettes::Swatch).to have_received(:generate).exactly(198).times

      expect(UtilityPalettes::Sequences).to have_received(:hsl).exactly(198).times
      expect(UtilityPalettes::Sequences).to have_received(:rgb).exactly(0).times

      expect(UtilityPalettes::Outputs).to have_received(:generate).exactly(1).times
      expect(UtilityPalettes::Outputs).to have_received(:json).exactly(1).times
      expect(UtilityPalettes::Outputs).to have_received(:scss).exactly(0).times
      expect(UtilityPalettes::Outputs).to have_received(:css).exactly(0).times
    end
  end

  context 'private methods' do
    it '.responds_to' do
      expect(described_class).to respond_to(:colourize_values)
      expect(described_class).to respond_to(:palette_looper)
      expect(described_class).to respond_to(:format_palette)
    end

    before do
      @palette_hash = { 'colour-a' => '#123456', 'colour-b' => '#654321' }
      @colorize_hash = { 'colour-a' => ColorConverters::Color.new('#123456'), 'colour-b' => ColorConverters::Color.new('#654321') }
      @generated_hash = {
        'colour-a-light' => ColorConverters::Color.new(h: 210.0, s: 59.38, l: 4.39),
        'colour-a' => ColorConverters::Color.new('#123456'),
        'colour-a-dark' => ColorConverters::Color.new(h: 210.0, s: 71.38, l: 36.39),
        'colour-b-light' => ColorConverters::Color.new(h: 30.0, s: 44.75, l: 10.27),
        'colour-b' => ColorConverters::Color.new('#654321'),
        'colour-b-dark' => ColorConverters::Color.new(h: 30.0, s: 56.75, l: 42.27)
      }
    end

    it '.colourize_values' do
      expect(described_class.colourize_values(@palette_hash)).to match_array @colorize_hash
    end

    it '.palette_looper' do
      expect(described_class.palette_looper(@colorize_hash, 'absolutes')).to match_array(
        {
          'colour-a-50' => ColorConverters::Color.new(h: 210.0, s: 86.38, l: 76.39),
          'colour-a-100' => ColorConverters::Color.new(h: 210.0, s: 83.38, l: 68.39),
          'colour-a-200' => ColorConverters::Color.new(h: 210.0, s: 80.38, l: 60.39),
          'colour-a-300' => ColorConverters::Color.new(h: 210.0, s: 77.38, l: 52.39),
          'colour-a-400' => ColorConverters::Color.new(h: 210.0, s: 74.38, l: 44.39),
          'colour-a-500' => ColorConverters::Color.new(h: 210.0, s: 71.38, l: 36.39),
          'colour-a-600' => ColorConverters::Color.new(h: 210.0, s: 68.38, l: 28.39),
          'colour-a-700' => ColorConverters::Color.new(h: 210.0, s: 65.38, l: 20.39),
          'colour-a-800' => ColorConverters::Color.new(h: 210.0, s: 62.38, l: 12.39),
          'colour-a-900' => ColorConverters::Color.new(h: 210.0, s: 59.38, l: 4.39),

          'colour-b-50' => ColorConverters::Color.new(h: 30.0, s: 71.75, l: 82.27),
          'colour-b-100' => ColorConverters::Color.new(h: 30.0, s: 68.75, l: 74.27),
          'colour-b-200' => ColorConverters::Color.new(h: 30.0, s: 65.75, l: 66.27),
          'colour-b-300' => ColorConverters::Color.new(h: 30.0, s: 62.75, l: 58.27),
          'colour-b-400' => ColorConverters::Color.new(h: 30.0, s: 59.75, l: 50.27),
          'colour-b-500' => ColorConverters::Color.new(h: 30.0, s: 56.75, l: 42.27),
          'colour-b-600' => ColorConverters::Color.new(h: 30.0, s: 53.75, l: 34.27),
          'colour-b-700' => ColorConverters::Color.new(h: 30.0, s: 50.75, l: 26.27),
          'colour-b-800' => ColorConverters::Color.new(h: 30.0, s: 47.75, l: 18.27),
          'colour-b-900' => ColorConverters::Color.new(h: 30.0, s: 44.75, l: 10.27)
        }
      )

      expect(described_class.palette_looper(@colorize_hash, 'relatives')).to match_array @generated_hash
    end

    it '.format_palette' do
      configuration = UtilityPalettes.configuration

      expect(described_class.format_palette(@generated_hash)).to match_array @generated_hash

      configuration.output_prefix = 'basic+'
      expect(described_class.format_palette(@generated_hash)).to eq(
        {
          'basic+colour-a-light' => ColorConverters::Color.new(h: 210.0, s: 59.38, l: 4.39),
          'basic+colour-a' => ColorConverters::Color.new('#123456'),
          'basic+colour-a-dark' => ColorConverters::Color.new(h: 210.0, s: 71.38, l: 36.39),
          'basic+colour-b-light' => ColorConverters::Color.new(h: 30.0, s: 44.75, l: 10.27),
          'basic+colour-b' => ColorConverters::Color.new('#654321'),
          'basic+colour-b-dark' => ColorConverters::Color.new(h: 30.0, s: 56.75, l: 42.27)
        }
      )

      # the .format_palette method is destructive so adjusts the used variable
      configuration.output_suffix = '--paint'
      expect(described_class.format_palette(@generated_hash)).to eq(
        {
          'basic+basic+colour-a-light--paint' => ColorConverters::Color.new(h: 210.0, s: 59.38, l: 4.39),
          'basic+basic+colour-a--paint' => ColorConverters::Color.new('#123456'),
          'basic+basic+colour-a-dark--paint' => ColorConverters::Color.new(h: 210.0, s: 71.38, l: 36.39),
          'basic+basic+colour-b-light--paint' => ColorConverters::Color.new(h: 30.0, s: 44.75, l: 10.27),
          'basic+basic+colour-b--paint' => ColorConverters::Color.new('#654321'),
          'basic+basic+colour-b-dark--paint' => ColorConverters::Color.new(h: 30.0, s: 56.75, l: 42.27)
        }
      )

      # the .format_palette method is destructive so adjusts the used variable
      configuration.output_prefix = nil
      expect(described_class.format_palette(@generated_hash)).to eq(
        {
          'basic+basic+colour-a-light--paint--paint' => ColorConverters::Color.new(h: 210.0, s: 59.38, l: 4.39),
          'basic+basic+colour-a--paint--paint' => ColorConverters::Color.new('#123456'),
          'basic+basic+colour-a-dark--paint--paint' => ColorConverters::Color.new(h: 210.0, s: 71.38, l: 36.39),
          'basic+basic+colour-b-light--paint--paint' => ColorConverters::Color.new(h: 30.0, s: 44.75, l: 10.27),
          'basic+basic+colour-b--paint--paint' => ColorConverters::Color.new('#654321'),
          'basic+basic+colour-b-dark--paint--paint' => ColorConverters::Color.new(h: 30.0, s: 56.75, l: 42.27)
        }
      )
    end
  end
end
