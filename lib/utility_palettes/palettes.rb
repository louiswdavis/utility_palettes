# frozen_string_literal: true

module UtilityPalettes
  class Palettes
    def self.generate
      configuration = UtilityPalettes.configuration

      puts 'Generating utility palettes...'

      default_absolutes = configuration.use_default_absolutes == true ? UtilityPalettes::Defaults.absolutes : {}
      default_relatives = configuration.use_default_relatives == true ? UtilityPalettes::Defaults.relatives : {}
      default_singles = configuration.use_default_singles == true ? UtilityPalettes::Defaults.singles : {}

      puts 'Defined default palettes...'

      user_absolutes = configuration.absolutes
      user_relatives = configuration.relatives
      user_singles = configuration.singles

      puts 'Retrieved user palettes...'

      # merging should mean any user colours will overwrite default colours with the same key names
      combined_absolutes = default_absolutes.merge(user_absolutes)
      combined_relatives = default_relatives.merge(user_relatives)
      combined_singles = {}.merge(default_absolutes, user_absolutes, default_singles, user_singles)

      @combined_samples = combined_absolutes.merge(combined_relatives).merge(combined_singles)

      puts 'Merged palettes...'

      converted_absolutes = self.colourize_values(combined_absolutes)
      converted_relatives = self.colourize_values(combined_relatives)
      converted_singles = self.colourize_values(combined_singles)

      puts 'Converted palettes...'

      generated_absolutes = self.palette_looper(converted_absolutes, 'absolutes')
      generated_relatives = self.palette_looper(converted_relatives, 'relatives')
      generated_singles = converted_singles

      puts 'Generated utility palettes...'

      generated_palettes = {}.merge(generated_absolutes, generated_relatives, generated_singles)
      generated_palettes = self.format_palette(generated_palettes)
      output_palettes = UtilityPalettes::Outputs.generate(generated_palettes)

      filename = configuration.output_filename
      filename += "-#{Time.zone.now.strftime('%Y%m%d-%H%M%S')}" if configuration.output_dated == true

      output_files = configuration.output_files.map(&:strip)

      UtilityPalettes::Outputs.json(filename, output_palettes) if output_files.include?('json')
      UtilityPalettes::Outputs.scss(filename, output_palettes) if output_files.include?('scss')
      UtilityPalettes::Outputs.css(filename, output_palettes) if output_files.include?('css')

      true
    end

    private

    def self.colourize_values(basic_hash)
      colourized_hash = {}

      basic_hash.each do |label, colour|
        begin
          if colour.is_a?(String) && colour.start_with?('$')
            # if the colour label begins with $ then it is a reference to a different defined colour, so must be looked up in the main
            colourized_hash[label] = ColorConverters::Color.new(@combined_samples.dig(colour.slice(1..-1).to_sym))
          else
            colourized_hash[label] = ColorConverters::Color.new(colour)
          end

          # TODO
          # provide a name if the label is left blank
          # if label.to_s == '$blank'
          #   hash[colourized_hash[label].name] = hash.delete(label)
          #   puts "Blank colour #{colour} has been given the name: #{colourized_hash[label].name}"
          # end
        rescue ColorConverters::InvalidColorError => e
          warn "Error processing colour #{label} with value #{colour}: #{e.message}"
        end
      end

      colourized_hash
    end

    # * Palettes

    # ? Multiple Colour's Palette
    # a function to loop through a map of colours and create absolute or relative palettes for them all and collect this into a single map

    def self.palette_looper(colourized_hash, palette_type)
      looped_generated_palettes = {}

      colourized_hash.each do |label, base_colour|
        # create a palette for a single colour from the providing mapping
        if palette_type == 'absolutes'
          generated_swatches = UtilityPalettes::Swatch.absolute_generator(label, base_colour)
        elsif palette_type == 'relatives'
          generated_swatches = UtilityPalettes::Swatch.relative_generator(label, base_colour)
        end

        # merge the colours absolute palette into the collective mapping
        looped_generated_palettes.merge!(generated_swatches)
      end

      looped_generated_palettes
    end

    def self.format_palette(generated_hash)
      configuration = UtilityPalettes.configuration

      generated_hash.transform_keys!(&:to_s)
      generated_hash.transform_keys! { |key| configuration.output_prefix + key } if configuration.output_prefix.present?
      generated_hash.transform_keys! { |key| key + configuration.output_suffix } if configuration.output_suffix.present?

      generated_hash
    end
  end
end
