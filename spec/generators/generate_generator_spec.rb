# frozen_string_literal: true

require 'generator_spec' # For testing Rails generators
require 'rails'          # To mock Rails environment components
require 'json'           # For parsing JSON config
require 'ostruct'        # For mocking Rails.application

require_relative '../../lib/generators/utility_palettes/generate_generator'

RSpec.describe UtilityPalettes::Generators::GenerateGenerator, type: :generator do
  destination File.expand_path('../tmp', __dir__)

  before do
    RSpec::Mocks.configuration.allow_message_expectations_on_nil = true

    # This placement resolves "expectation set on nil" warnings by guaranteeing the object is there.
    Object.const_set(:Rails, Module.new) unless defined?(Rails)
    Rails.const_set(:application, OpenStruct.new) unless defined?(Rails.application)

    prepare_destination

    # Default stubs for file existence (most tests will override these)
    allow(File).to receive(:exist?).and_return(false)
    allow(File).to receive(:exist?).with('config/utility_palettes.yml').and_return(false)
    allow(File).to receive(:exist?).with('config/utility_palettes.json').and_return(false)

    # Default stubs for Rails config_for (most tests will override these)
    allow(Rails.application).to receive(:config_for).and_return(nil)

    # Stub the actual generation call so we don't try to run it
    allow(UtilityPalettesRails::Palettes).to receive(:generate)
    allow(described_class).to receive(:disabled_warn).and_call_original
    allow(described_class).to receive(:config_format_warn).and_call_original
  end

  context 'when YAML config exists' do
    before do
      allow(File).to receive(:exist?).with('config/utility_palettes.yml').and_return(true)
      allow(self).to receive(:defined?).with('Rails.application.config_for').and_return(true)
    end

    it 'and loads config and calls generate' do
      file = YAML.load_file('spec/fixtures/utility_palettes.yml')
      allow(Rails.application).to receive(:config_for).with(:utility_palettes).and_return(file['test'])

      expected_config = file['test']['utility_palettes']
      expect(expected_config.length).to eq 5
      expect(expected_config.dig(:disabled)).to eq nil

      run_generator

      expect(UtilityPalettesRails::Palettes).to have_received(:generate).once
      expect(UtilityPalettesRails::Palettes).to have_received(:generate).with(expected_config)
      expect(described_class).not_to have_received(:disabled_warn)
      expect(described_class).not_to have_received(:config_format_warn)
    end

    it 'and loads config and disables generate' do
      file = YAML.load_file('spec/fixtures/utility_palettes_disabled.yml')
      allow(Rails.application).to receive(:config_for).with(:utility_palettes).and_return(file['test'])

      expected_config = file['test']['utility_palettes']
      expect(expected_config.length).to eq 6
      expect(expected_config.dig('disabled')).to eq true

      run_generator

      expect(UtilityPalettesRails::Palettes).not_to have_received(:generate)
      expect(described_class).to have_received(:disabled_warn).once
      expect(described_class).not_to have_received(:config_format_warn)
    end

    it 'and loads config and it is not formatted correctly' do
      file = { 'test' => { 'utility_palettes' => nil } }
      allow(Rails.application).to receive(:config_for).with(:utility_palettes).and_return(file['test'])

      run_generator

      expect(UtilityPalettesRails::Palettes).not_to have_received(:generate)
      expect(described_class).not_to have_received(:disabled_warn)
      expect(described_class).to have_received(:config_format_warn).once
    end
  end

  context 'when JSON config exists' do
    before do
      allow(File).to receive(:exist?).with('config/utility_palettes.json').and_return(true)
    end

    it 'loads config and calls generate' do
      file = File.read('spec/fixtures/utility_palettes.json')
      allow(File).to receive(:read).with('config/utility_palettes.json').and_return(file)

      expected_config = JSON.parse(file)['test']['utility_palettes']
      expect(expected_config.length).to eq 5
      expect(expected_config.dig('disabled')).to eq nil

      run_generator

      expect(UtilityPalettesRails::Palettes).to have_received(:generate).once
      expect(UtilityPalettesRails::Palettes).to have_received(:generate).with(expected_config)
      expect(described_class).not_to have_received(:disabled_warn)
      expect(described_class).not_to have_received(:config_format_warn)
    end

    it 'and loads config and disables generate' do
      file = File.read('spec/fixtures/utility_palettes_disabled.json')
      allow(File).to receive(:read).with('config/utility_palettes.json').and_return(file)

      expected_config = JSON.parse(file)['test']['utility_palettes']
      expect(expected_config.length).to eq 6
      expect(expected_config.dig('disabled')).to eq true

      run_generator

      expect(UtilityPalettesRails::Palettes).not_to have_received(:generate)
      expect(described_class).to have_received(:disabled_warn).once
      expect(described_class).not_to have_received(:config_format_warn)
    end

    it 'and loads config and it is not formatted correctly' do
      file = { 'test' => { 'utility_palettes' => nil } }.to_json
      allow(File).to receive(:read).with('config/utility_palettes.json').and_return(file)

      run_generator

      expect(UtilityPalettesRails::Palettes).not_to have_received(:generate)
      expect(described_class).not_to have_received(:disabled_warn)
      expect(described_class).to have_received(:config_format_warn).once
    end
  end

  context 'when neither YAML nor JSON config files exist' do
    it 'and calls generate' do
      run_generator

      expect(UtilityPalettesRails::Palettes).to have_received(:generate).once.with({})
      expect(described_class).not_to have_received(:disabled_warn)
      expect(described_class).not_to have_received(:config_format_warn)
    end
  end
end
