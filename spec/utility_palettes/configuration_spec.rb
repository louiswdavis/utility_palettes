# frozen_string_literal: true

RSpec.describe UtilityPalettes::Configuration do
  context 'attributes' do
    it 'tests all declared attribute accessors' do
      # You can manually list what you expect to be there
      expected_accessors = [
        :enable_environments,
        :use_default_absolutes, :use_default_relatives, :use_default_singles,
        :output_dated, :output_files, :output_format, :output_prefix, :output_suffix,
        :method, :steps_h, :steps_s, :steps_l, :steps_r, :steps_g, :steps_b,
        :absolutes, :relatives, :singles
      ]

      expected_defaults = [[:development], true, true, true, 'utility_palettes', false, ['json'], 'hex', '', '', 'hsl', 0, 3, 8, 9, 9, 9, {}, {}, {}]

      configuration_class = UtilityPalettes::Configuration.new
      configuration = described_class.new

      actual_accessors = configuration_class.methods.reject { |m| m.to_s.end_with?('=') }.reject { |m| m.to_s.start_with?('_') }.reject { |m| m.to_s.start_with?('!') }.select { |m| configuration_class.respond_to?("#{m}=") }

      expect(actual_accessors.length).to eq 19
      expect(expected_accessors.length).to eq 19
      expect(actual_accessors).to match_array expected_accessors

      expected_accessors.each_with_index do |accessor, index|
        expect(configuration_class).to respond_to(accessor)
        expect(configuration_class).to respond_to("#{accessor}=")

        expect(configuration.send(accessor)).to eq expected_defaults[index]
      end
    end

    it '.setters' do
      configuration = described_class.new
      configuration.enable_environments = [:something]
      expect(configuration.enable_environments).to eq([:something])
    end
  end

  context 'methods' do
    it '.responds_to' do
      expect(described_class.new).to respond_to(:reset!)
      expect(described_class.new).to respond_to(:validate_settings)

      expect(UtilityPalettes).to respond_to(:configuration)
      expect(UtilityPalettes).to respond_to(:reset_configuration!)
    end

    it '.reset!' do
      configuration = described_class.new
      configuration.enable_environments = [:something]

      configuration.reset!
      expect(configuration.enable_environments).to eq([:development])
    end

    it '.validate_settings' do
    end
  end

  context 'usage' do
    it 'returns a Configuration instance' do
      expect(UtilityPalettes.configuration).to be_a(UtilityPalettes::Configuration)
    end

    it 'returns the same instance on multiple calls' do
      config1 = UtilityPalettes.configuration
      config2 = UtilityPalettes.configuration
      expect(config1).to be(config2)
    end

    it '.reset_configuration! on the Configuration instance' do
      configuration = UtilityPalettes.configuration

      configuration.enable_environments = [:something]
      expect(configuration.enable_environments).to eq([:something])

      UtilityPalettes.reset_configuration!

      # Get the NEW configuration instance after reset
      new_configuration = UtilityPalettes.configuration
      expect(new_configuration.enable_environments).to eq([:development])

      # Optional: also test that it's actually a different instance
      expect(new_configuration).not_to be(configuration)
    end
  end
end
