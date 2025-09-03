# frozen_string_literal: true

require 'rails'          # To mock Rails environment components
require 'ostruct'        # For mocking Rails.application

require_relative '../../lib/generators/utility_palettes/generate_generator'

RSpec.describe UtilityPalettes::Generators::GenerateGenerator, type: :generator do
  destination File.expand_path('../tmp', __dir__)

  before do
    RSpec::Mocks.configuration.allow_message_expectations_on_nil = true

    # Default stubs for file existence (most tests will override these)
    allow(File).to receive(:exist?).and_return(false)
    allow(File).to receive(:exist?).with('config/utility_palettes.yml').and_return(false)
    allow(File).to receive(:exist?).with('config/utility_palettes.json').and_return(false)

    # Stub the actual generation call so we don't try to run it
    allow(UtilityPalettes::Palettes).to receive(:generate).and_call_original
    allow(described_class).to receive(:disabled_warn).and_call_original
    allow(described_class).to receive(:config_format_warn).and_call_original
  end

  it 'and loads config and calls generate' do
    configuration = UtilityPalettes.configuration
    configuration.output_files = ['json', 'scss', 'css']

    run_generator

    expect(UtilityPalettes::Palettes).to have_received(:generate).once
    expect(described_class).not_to have_received(:disabled_warn)
    expect(described_class).not_to have_received(:config_format_warn)

    # assert_file and File.exist? don't work for some reason
    expect(File.file?(File.join(destination_root, 'outputs/utility_palettes.json'))).to be true
    expect(File.file?(File.join(destination_root, 'outputs/utility_palettes.scss'))).to be true
    expect(File.file?(File.join(destination_root, 'outputs/utility_palettes.css'))).to be true
  end

  it 'and loads config and disables generate' do
    configuration = UtilityPalettes.configuration
    configuration.enable_environments = []

    run_generator

    expect(UtilityPalettes::Palettes).not_to have_received(:generate)
    expect(described_class).to have_received(:disabled_warn).once
    expect(described_class).not_to have_received(:config_format_warn)
  end

  it 'and loads YML config files and warns the user' do
    allow(File).to receive(:exist?).with('config/utility_palettes.yml').and_return(true)

    run_generator

    expect(UtilityPalettes::Palettes).to have_received(:generate)
    expect(described_class).not_to have_received(:disabled_warn)
    expect(described_class).to have_received(:config_format_warn).once
  end

  it 'and loads JSON config files and warns the user' do
    allow(File).to receive(:exist?).with('config/utility_palettes.json').and_return(true)

    run_generator

    expect(UtilityPalettes::Palettes).to have_received(:generate)
    expect(described_class).not_to have_received(:disabled_warn)
    expect(described_class).to have_received(:config_format_warn).once
  end
end
