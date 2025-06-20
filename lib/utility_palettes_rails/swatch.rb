module UtilityPalettesRails
  class Swatch
    # ? Single Colour's Palette
    # a function to create an absolute palette that incorporates a single colour input
    def self.absolute_generator(label, base_colour, method, sequence_steps)
      @method = method
      @sequence_steps = sequence_steps

      generated_absolute_swatches = {}

      # colours are index inversely to their lightness
      base_swatch_lightness_index = UtilityPalettesRails::Swatch.lightness_index(base_colour)
      generated_absolute_swatches = {}.merge(generated_absolute_swatches, { UtilityPalettesRails::Swatch.label(label, base_swatch_lightness_index) => base_colour })

      # Lighter colours
      # calc the space available to create lightened colours based off the base colour
      if base_swatch_lightness_index > 0
        for i in 0..base_swatch_lightness_index do
          lighter_colour = UtilityPalettesRails::Swatch.generate(base_colour, i, true)
          generated_absolute_swatches = {}.merge(generated_absolute_swatches, { UtilityPalettesRails::Swatch.label(label, base_swatch_lightness_index - i) => lighter_colour })
        end
      end

      # # Darker colours
      # # calc the space available to create darkened colours based off the base colour
      if base_swatch_lightness_index < 9
        for i in 0..(9 - base_swatch_lightness_index) do
          darker_colour = UtilityPalettesRails::Swatch.generate(base_colour, i, false)
          generated_absolute_swatches = {}.merge(generated_absolute_swatches, { UtilityPalettesRails::Swatch.label(label, base_swatch_lightness_index + i) => darker_colour })
        end
      end

      generated_absolute_swatches
    end

    # ? Single Colour's Relative Palette
    # a function to create a relative palette centred on a single colour input
    def self.relative_generator(label, base_colour, method, sequence_steps)
      @method = method
      @sequence_steps = sequence_steps

      generated_relative_swatches = {}
      lighter_colour = nil
      darker_colour = nil

      base_swatch_lightness_index = UtilityPalettesRails::Swatch.lightness_index(base_colour)

      # Lighter Colour
      if base_swatch_lightness_index > 1
        lighter_colour = UtilityPalettesRails::Swatch.generate(base_colour, 2, true)
      elsif base_swatch_lightness_index > 0
        lighter_colour = UtilityPalettesRails::Swatch.generate(base_colour, 1, true)
      else
        lighter_colour = nil
      end
      
      # Darker Colour
      if base_swatch_lightness_index < 8
        darker_colour = UtilityPalettesRails::Swatch.generate(base_colour, 2, false)
      elsif base_swatch_lightness_index < 9
        darker_colour = UtilityPalettesRails::Swatch.generate(base_colour, 1, false)
      else
        darker_colour = nil
      end

      generated_relative_swatches = {}.merge(generated_relative_swatches, { label => base_colour })
      generated_relative_swatches = {}.merge(generated_relative_swatches, { label.to_s + '-light' => lighter_colour })
      generated_relative_swatches = {}.merge(generated_relative_swatches, { label.to_s + '-dark' => darker_colour })

      generated_relative_swatches
    end

    def self.lightness_index(colour)
      9 - (colour.hsl[:l] / 10).floor
    end

    def self.label(label, index)
      if index == 0
        label.to_s + '-50'
      else
        label.to_s + '-' + index.to_s + '00'
      end
    end

    # TODO create other sequence methods
    # ? How to Calculate the next colour in the Palette
    def self.generate(colour, step, go_lighter)
      case @method
      when 'hsl'
        UtilityPalettesRails::Sequences.hsl(colour, step, go_lighter, @sequence_steps)
      else
        UtilityPalettesRails::Sequences.hsl(colour, step, go_lighter, @sequence_steps)
      end
    end
  end
end
