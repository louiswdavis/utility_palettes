# frozen_string_literal: true

require 'spec_helper'

RSpec.describe UtilityPalettes::Configuration do
  context 'methods' do
    it 'setup' do
      expect(described_class.setup({})).to eq({ h_step: 0, s_step: 2, l_step: 9 })
      expect(described_class.setup({ steps: { h: 5, s: 9, l: 12 } })).to eq({ h_step: 5, s_step: 9, l_step: 12 })
    end

    it 'defaults' do
      expect(described_class.defaults).to eq(
        {
          'rgb' => { r: '7%', g: '7%', b: '7%' },
          'hsl' => { h: 0, s: 2, l: 9 }
        }
      )
    end
  end
end
