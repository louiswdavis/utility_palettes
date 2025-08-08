# frozen_string_literal: true

require 'spec_helper'

RSpec.describe UtilityPalettes::Validations do
  context 'methods' do
    it '.validate_config' do
      expect(described_class.validate_config({})).to eq true
    end
  end
end
