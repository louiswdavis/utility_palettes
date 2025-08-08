# frozen_string_literal: true

require 'spec_helper'

RSpec.describe UtilityPalettes::Defaults do
  context 'methods' do
    it 'absolutes' do
      expect(described_class.absolutes).to eq(
        {
          'red' => 'hsl(2, 78%, 64%)',
          'rust' => 'hsl(16, 82%, 62%)',
          'orange' => 'hsl(31, 90%, 65%)',
          'gold' => 'hsl(46, 93%, 54%)',
          'yellow' => 'hsl(58, 87%, 55%)',
          'pear' => 'hsl(80, 74%, 57%)',
          'green' => 'hsl(110, 69%, 58%)',
          'seaside' => 'hsl(156, 78%, 57%)',
          'cyan' => 'hsl(180, 69%, 37%)',
          'capri' => 'hsl(197, 90%, 46%)',
          'blue' => 'hsl(214, 78%, 36%)',
          'iris' => 'hsl(265, 87%, 57%)',
          'purple' => 'hsl(279, 85%, 56%)',
          'magenta' => 'hsl(300, 64%, 66%)',
          'pink' => 'hsl(320, 74%, 66%)',
          'satin' => 'hsl(348, 74%, 57%)',
          'cement' => 'hsl(42, 6%, 87%)',
          'grey' => 'hsl(0, 3%, 46%)',
          'base' => 'hsl(0, 3%, 46%)'
        }
      )
    end

    it 'relatives' do
      expect(described_class.relatives).to eq(
        {
          'success' => 'hsl(110, 69%, 58%)',
          'danger' => 'hsl(2, 78%, 64%)',
          'information' => 'hsl(214, 78%, 36%)',
          'warning' => 'hsl(46, 93%, 54%)'
        }
      )
    end

    it 'singles' do
      expect(described_class.singles).to eq(
        {
          'white' => '#fff',
          'black' => '#000',
          'translucent' => 'rgba(0, 0, 0, 0.45)'
        }
      )
    end
  end
end
