# frozen_string_literal: true

module UtilityPalettes
  class Swatch
    # ? Single Colour's Palette
    # a function to create an absolute palette that incorporates a single colour input
    def self.absolute_generator(label, base_colour)
      @method = UtilityPalettes.configuration.method

      # colours are index inversely to their lightness
      base_level = UtilityPalettes::Swatch.base_lightness_index(base_colour)
      generated_absolute_swatches = { UtilityPalettes::Swatch.label(label, base_level) => base_colour }

      # TODO: remove once confident the lower loop is equivalent to these
      # # Lighter colours
      # # calc the space available to create lightened colours based off the base colour
      # if base_level.positive?
      #   (0..base_level).each do |new_level|
      #     new_colour = UtilityPalettes::Swatch.generate(base_colour, base_level, new_level)
      #     generated_absolute_swatches = {}.merge(generated_absolute_swatches, { UtilityPalettes::Swatch.label(label, new_level) => new_colour })
      #   end
      # end

      # # Darker colours
      # # calc the space available to create darkened colours based off the base colour
      # if base_level < 9
      #   (base_level..9).each do |new_level|
      #     new_colour = UtilityPalettes::Swatch.generate(base_colour, base_level, new_level)
      #     generated_absolute_swatches = {}.merge(generated_absolute_swatches, { UtilityPalettes::Swatch.label(label, new_level) => new_colour })
      #   end
      # end

      if base_level.positive?
        (0..9).each do |new_level|
          new_colour = UtilityPalettes::Swatch.generate(base_colour, base_level, new_level)
          generated_absolute_swatches.merge!({ UtilityPalettes::Swatch.label(label, new_level) => new_colour })
        end
      end

      generated_absolute_swatches
    end

    # ? Single Colour's Relative Palette
    # a function to create a relative palette centred on a single colour input
    def self.relative_generator(label, base_colour)
      @method = UtilityPalettes.configuration.method

      lighter_colour = nil
      darker_colour = nil

      # colours are index inversely to their lightness
      base_level = UtilityPalettes::Swatch.base_lightness_index(base_colour)
      generated_relative_swatches = { label => base_colour }

      # Lighter Colour
      if base_level > 1
        lighter_colour = UtilityPalettes::Swatch.generate(base_colour, base_level, base_level + 2)
      elsif base_level.positive?
        lighter_colour = UtilityPalettes::Swatch.generate(base_colour, base_level, base_level + 1)
      else
        lighter_colour = nil
      end

      # Darker Colour
      if base_level < 8
        darker_colour = UtilityPalettes::Swatch.generate(base_colour, base_level, base_level - 2)
      elsif base_level < 9
        darker_colour = UtilityPalettes::Swatch.generate(base_colour, base_level, base_level - 1)
      else
        darker_colour = nil
      end

      generated_relative_swatches.merge!({ "#{label}-light" => lighter_colour })
      generated_relative_swatches.merge!({ "#{label}-dark" => darker_colour })

      generated_relative_swatches
    end

    def self.base_lightness_index(colour)
      9 - (colour.hsl[:l] / 10).floor
    end

    def self.label(label, index)
      levels = { '0' => 50, '1' => 100, '2' => 200, '3' => 300, '4' => 400, '5' => 500, '6' => 600, '7' => 700, '8' => 800, '9' => 900 }

      [label, levels.dig(index.to_s)].join('-')
    end

    # TODO: create other sequence methods
    # ? How to Calculate the next colour in the Palette
    def self.generate(colour, base_level, new_level)
      case @method
      when 'hsl'
        UtilityPalettes::Sequences.hsl(colour, new_level - base_level)
      when 'rgb'
        # TODO
      else
        UtilityPalettes::Sequences.hsl(colour, new_level - base_level)
      end
    end

    def build_step_check
      # const ALL_LEVELS = [50, 100, 200, 300, 400, 600, 700, 800, 900];
      # const levels = options.levels == null ? ALL_LEVELS : options.levels.filter(level => ALL_LEVELS.includes(level));
    end
  end
end
