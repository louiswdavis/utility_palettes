# frozen_string_literal: true

require 'json'
require 'tempfile'

require_relative 'utility_palettes/version'

require_relative 'utility_palettes/configuration'
require_relative 'utility_palettes/defaults'
require_relative 'utility_palettes/outputs'
require_relative 'utility_palettes/palettes'
require_relative 'utility_palettes/sequences'
require_relative 'utility_palettes/swatch'

module UtilityPalettes
  class Error < StandardError; end
  # Your code goes here...
end
