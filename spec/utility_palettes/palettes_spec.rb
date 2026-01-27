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
      expect(UtilityPalettes::Outputs).to have_received(:json).exactly(0).times
      expect(UtilityPalettes::Outputs).to have_received(:scss).exactly(1).times
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
      @palette_hash = { 'colour-a' => '#123456', 'colour-b' => { h: 30.0, s: 50.75, l: 26.27 }, 'colour-c' => '$colour-d', 'colour-d' => '$colour-a' }
      @colorize_hash = {
        'colour-a' => ColorConverters::Color.new('#123456'),
        'colour-b' => ColorConverters::Color.new(h: 30.0, s: 50.75, l: 26.27),
        'colour-c' => ColorConverters::Color.new('#123456'),
        'colour-d' => ColorConverters::Color.new('#123456'),
      }
      @generated_relative_hash = {
        'colour-a-light' => ColorConverters::Color.new(h: 210.0, s: 59.38, l: 4.39),
        'colour-a' => ColorConverters::Color.new('#123456'),
        'colour-a-dark' => ColorConverters::Color.new(h: 210.0, s: 71.38, l: 36.39),
        'colour-b-light' => ColorConverters::Color.new(h: 30.0, s: 44.75, l: 10.27),
        'colour-b' => ColorConverters::Color.new(h: 30.0, s: 50.75, l: 26.27),
        'colour-b-dark' => ColorConverters::Color.new(h: 30.0, s: 56.75, l: 42.27),
        'colour-c-light' => ColorConverters::Color.new(h: 210.0, s: 59.38, l: 4.39),
        'colour-c' => ColorConverters::Color.new('#123456'),
        'colour-c-dark' => ColorConverters::Color.new(h: 210.0, s: 71.38, l: 36.39),
        'colour-d-light' => ColorConverters::Color.new(h: 210.0, s: 59.38, l: 4.39),
        'colour-d' => ColorConverters::Color.new('#123456'),
        'colour-d-dark' => ColorConverters::Color.new(h: 210.0, s: 71.38, l: 36.39),
      }

      UtilityPalettes::Palettes.instance_variable_set(:@combined_samples, @palette_hash)
    end

    it '.colourize_values' do
      expect(described_class.colourize_values(@palette_hash)).to match_array @colorize_hash

      infinite_loop_hash = { 'colour-a' => '$colour-b', 'colour-b' => '$colour-d', 'colour-c' => '$colour-e', 'colour-d' => '$colour-a' }
      UtilityPalettes::Palettes.instance_variable_set(:@combined_samples, infinite_loop_hash)
      expect(described_class.colourize_values(infinite_loop_hash)).to eq({})
      expect { described_class.colourize_values(infinite_loop_hash) }.to output(/Circular reference detected/).to_stderr
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
          'colour-b-900' => ColorConverters::Color.new(h: 30.0, s: 44.75, l: 10.27),

          'colour-c-50' => ColorConverters::Color.new(h: 210.0, s: 86.38, l: 76.39),
          'colour-c-100' => ColorConverters::Color.new(h: 210.0, s: 83.38, l: 68.39),
          'colour-c-200' => ColorConverters::Color.new(h: 210.0, s: 80.38, l: 60.39),
          'colour-c-300' => ColorConverters::Color.new(h: 210.0, s: 77.38, l: 52.39),
          'colour-c-400' => ColorConverters::Color.new(h: 210.0, s: 74.38, l: 44.39),
          'colour-c-500' => ColorConverters::Color.new(h: 210.0, s: 71.38, l: 36.39),
          'colour-c-600' => ColorConverters::Color.new(h: 210.0, s: 68.38, l: 28.39),
          'colour-c-700' => ColorConverters::Color.new(h: 210.0, s: 65.38, l: 20.39),
          'colour-c-800' => ColorConverters::Color.new(h: 210.0, s: 62.38, l: 12.39),
          'colour-c-900' => ColorConverters::Color.new(h: 210.0, s: 59.38, l: 4.39),

          'colour-d-50' => ColorConverters::Color.new(h: 210.0, s: 86.38, l: 76.39),
          'colour-d-100' => ColorConverters::Color.new(h: 210.0, s: 83.38, l: 68.39),
          'colour-d-200' => ColorConverters::Color.new(h: 210.0, s: 80.38, l: 60.39),
          'colour-d-300' => ColorConverters::Color.new(h: 210.0, s: 77.38, l: 52.39),
          'colour-d-400' => ColorConverters::Color.new(h: 210.0, s: 74.38, l: 44.39),
          'colour-d-500' => ColorConverters::Color.new(h: 210.0, s: 71.38, l: 36.39),
          'colour-d-600' => ColorConverters::Color.new(h: 210.0, s: 68.38, l: 28.39),
          'colour-d-700' => ColorConverters::Color.new(h: 210.0, s: 65.38, l: 20.39),
          'colour-d-800' => ColorConverters::Color.new(h: 210.0, s: 62.38, l: 12.39),
          'colour-d-900' => ColorConverters::Color.new(h: 210.0, s: 59.38, l: 4.39),
        }
      )

      expect(described_class.palette_looper(@colorize_hash, 'relatives')).to match_array @generated_relative_hash
    end

    it '.format_palette' do
      configuration = UtilityPalettes.configuration

      generated_hash = @generated_relative_hash.dup # create a copy rather than just another assignment
      expect(described_class.format_palette(generated_hash)).to match_array(
        {
          'colour-a-light' => ColorConverters::Color.new(h: 210.0, s: 59.38, l: 4.39),
          'colour-a' => ColorConverters::Color.new('#123456'),
          'colour-a-dark' => ColorConverters::Color.new(h: 210.0, s: 71.38, l: 36.39),
          'colour-b-light' => ColorConverters::Color.new(h: 30.0, s: 44.75, l: 10.27),
          'colour-b' => ColorConverters::Color.new(h: 30.0, s: 50.75, l: 26.27),
          'colour-b-dark' => ColorConverters::Color.new(h: 30.0, s: 56.75, l: 42.27),
          'colour-c-light' => ColorConverters::Color.new(h: 210.0, s: 59.38, l: 4.39),
          'colour-c' => ColorConverters::Color.new('#123456'),
          'colour-c-dark' => ColorConverters::Color.new(h: 210.0, s: 71.38, l: 36.39),
          'colour-d-light' => ColorConverters::Color.new(h: 210.0, s: 59.38, l: 4.39),
          'colour-d' => ColorConverters::Color.new('#123456'),
          'colour-d-dark' => ColorConverters::Color.new(h: 210.0, s: 71.38, l: 36.39),
        }
      )

      # prefix
      configuration.output_prefix = 'basic+'

      generated_hash = @generated_relative_hash.dup # create a copy rather than just another assignment
      expect(described_class.format_palette(generated_hash)).to eq(
        {
          'basic+colour-a-light' => ColorConverters::Color.new(h: 210.0, s: 59.38, l: 4.39),
          'basic+colour-a' => ColorConverters::Color.new('#123456'),
          'basic+colour-a-dark' => ColorConverters::Color.new(h: 210.0, s: 71.38, l: 36.39),
          'basic+colour-b-light' => ColorConverters::Color.new(h: 30.0, s: 44.75, l: 10.27),
          'basic+colour-b' => ColorConverters::Color.new(h: 30.0, s: 50.75, l: 26.27),
          'basic+colour-b-dark' => ColorConverters::Color.new(h: 30.0, s: 56.75, l: 42.27),
          'basic+colour-c-light' => ColorConverters::Color.new(h: 210.0, s: 59.38, l: 4.39),
          'basic+colour-c' => ColorConverters::Color.new('#123456'),
          'basic+colour-c-dark' => ColorConverters::Color.new(h: 210.0, s: 71.38, l: 36.39),
          'basic+colour-d-light' => ColorConverters::Color.new(h: 210.0, s: 59.38, l: 4.39),
          'basic+colour-d' => ColorConverters::Color.new('#123456'),
          'basic+colour-d-dark' => ColorConverters::Color.new(h: 210.0, s: 71.38, l: 36.39),
        }
      )

      # prefix and suffix
      configuration.output_suffix = '--paint'

      generated_hash = @generated_relative_hash.dup # create a copy rather than just another assignment
      expect(described_class.format_palette(generated_hash)).to eq(
        {
          'basic+colour-a-light--paint' => ColorConverters::Color.new(h: 210.0, s: 59.38, l: 4.39),
          'basic+colour-a--paint' => ColorConverters::Color.new('#123456'),
          'basic+colour-a-dark--paint' => ColorConverters::Color.new(h: 210.0, s: 71.38, l: 36.39),
          'basic+colour-b-light--paint' => ColorConverters::Color.new(h: 30.0, s: 44.75, l: 10.27),
          'basic+colour-b--paint' => ColorConverters::Color.new(h: 30.0, s: 50.75, l: 26.27),
          'basic+colour-b-dark--paint' => ColorConverters::Color.new(h: 30.0, s: 56.75, l: 42.27),
          'basic+colour-c-light--paint' => ColorConverters::Color.new(h: 210.0, s: 59.38, l: 4.39),
          'basic+colour-c--paint' => ColorConverters::Color.new('#123456'),
          'basic+colour-c-dark--paint' => ColorConverters::Color.new(h: 210.0, s: 71.38, l: 36.39),
          'basic+colour-d-light--paint' => ColorConverters::Color.new(h: 210.0, s: 59.38, l: 4.39),
          'basic+colour-d--paint' => ColorConverters::Color.new('#123456'),
          'basic+colour-d-dark--paint' => ColorConverters::Color.new(h: 210.0, s: 71.38, l: 36.39),
        }
      )

      # suffix
      configuration.output_prefix = nil

      generated_hash = @generated_relative_hash.dup # create a copy rather than just another assignment
      expect(described_class.format_palette(generated_hash)).to eq(
        {
          'colour-a-light--paint' => ColorConverters::Color.new(h: 210.0, s: 59.38, l: 4.39),
          'colour-a--paint' => ColorConverters::Color.new('#123456'),
          'colour-a-dark--paint' => ColorConverters::Color.new(h: 210.0, s: 71.38, l: 36.39),
          'colour-b-light--paint' => ColorConverters::Color.new(h: 30.0, s: 44.75, l: 10.27),
          'colour-b--paint' => ColorConverters::Color.new(h: 30.0, s: 50.75, l: 26.27),
          'colour-b-dark--paint' => ColorConverters::Color.new(h: 30.0, s: 56.75, l: 42.27),
          'colour-c-light--paint' => ColorConverters::Color.new(h: 210.0, s: 59.38, l: 4.39),
          'colour-c--paint' => ColorConverters::Color.new('#123456'),
          'colour-c-dark--paint' => ColorConverters::Color.new(h: 210.0, s: 71.38, l: 36.39),
          'colour-d-light--paint' => ColorConverters::Color.new(h: 210.0, s: 59.38, l: 4.39),
          'colour-d--paint' => ColorConverters::Color.new('#123456'),
          'colour-d-dark--paint' => ColorConverters::Color.new(h: 210.0, s: 71.38, l: 36.39),
        }
      )
    end
  end
end
