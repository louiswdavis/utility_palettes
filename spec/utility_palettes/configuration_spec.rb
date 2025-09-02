# frozen_string_literal: true

RSpec.describe UtilityPalettes::Configuration do
  context 'attributes' do
    it 'tests all declared attribute accessors' do
      # You can manually list what you expect to be there
      expected_accessors = [
        :enable_environments,
        :use_default_absolutes, :use_default_relatives, :use_default_singles,
        :output_filename, :output_dated, :output_files, :output_format, :output_prefix, :output_suffix,
        :method, :steps_h, :steps_s, :steps_l, :steps_r, :steps_g, :steps_b,
        :absolutes, :relatives, :singles
      ]

      configuration_class = UtilityPalettes::Configuration.new

      actual_accessors = configuration_class.methods.reject { |m| m.to_s.end_with?('=') }.reject { |m| m.to_s.start_with?('_') }.reject { |m| m.to_s.start_with?('!') }.select { |m| configuration_class.respond_to?("#{m}=") }

      expect(actual_accessors.length).to eq 20
      expect(expected_accessors.length).to eq 20
      expect(actual_accessors).to match_array expected_accessors

      expected_accessors.each do |accessor|
        expect(configuration_class).to respond_to(accessor)
        expect(configuration_class).to respond_to("#{accessor}=")
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

    it '.initialize' do
      configuration = described_class.new

      expect(configuration.enable_environments).to eq([:development])

      expect(configuration.use_default_absolutes).to eq true
      expect(configuration.use_default_relatives).to eq true
      expect(configuration.use_default_singles).to eq true

      expect(configuration.output_dated).to eq false
      expect(configuration.output_files).to eq ['json']
      expect(configuration.output_format).to eq 'hex'
      expect(configuration.output_prefix).to eq ''
      expect(configuration.output_suffix).to eq ''

      expect(configuration.method).to eq 'hsl'

      expect(configuration.steps_h).to eq 0
      expect(configuration.steps_s).to eq 3
      expect(configuration.steps_l).to eq 8

      expect(configuration.absolutes).to eq({})
      expect(configuration.relatives).to eq({})
      expect(configuration.singles).to eq({})
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
