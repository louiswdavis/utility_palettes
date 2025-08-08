# frozen_string_literal: true

module UtilityPalettes
  class Palettes
    def self.generate(config)
      @config = config

      puts 'Generating utility palettes...'

      UtilityPalettes::Validations.validate_config(@config)
      @increment_steppers = UtilityPalettes::Configuration.setup(@config)

      puts 'Retrieved configuration...'

      default_absolutes = @config.dig(:defaults, :absolutes) == false ? {} : UtilityPalettes::Defaults.absolutes
      default_relatives = @config.dig(:defaults, :relatives) == false ? {} : UtilityPalettes::Defaults.relatives
      default_singles = @config.dig(:defaults, :singles) == false ? {} : UtilityPalettes::Defaults.singles

      puts 'Defined default palettes...'

      user_absolutes = @config.dig(:absolutes) || {}
      user_relatives = @config.dig(:relatives) || {}
      user_singles = @config.dig(:singles) || {}

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
      output_palettes = UtilityPalettes::Outputs.generate(generated_palettes, @config)

      filename = 'utility_palettes'
      filename += "-#{Time.zone.now.strftime('%Y%m%d-%H%M%S')}" if @config.dig(:output, :dated) == true

      output_files = (@config.dig(:output, :files) || '').split(',').map(&:strip)

      file = nil
      file = UtilityPalettes::Outputs.json(filename, output_palettes) if output_files.blank? || output_files.include?('json')
      File.rename(file.path, "#{filename}.json") if file.present?
      
      file = nil
      file = UtilityPalettes::Outputs.scss(filename, output_palettes) if output_files.include?('scss')
      File.rename(file.path, "app/assets/stylesheets/#{filename}.scss") if file.present?

      file = nil
      file = UtilityPalettes::Outputs.css(filename, output_palettes) if output_files.include?('css')
      File.rename(file.path, "app/assets/stylesheets/#{filename}.css") if file.present?

      true
    end

    private

    def self.colourize_values(colour_hash)
      colourized_hash = {}

      colour_hash.each do |label, colour|
        begin
          if colour.start_with?('$')
            # if the colour label begins with $ then it is a reference to a different defined colour, so must be looked up in the main
            colourized_hash[label] = ColorConverters::Color.new(@combined_samples.dig(colour[1..].to_sym))
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

    def self.palette_looper(colour_map, method)
      looped_generated_palettes = {}

      colour_map.each do |label, base_colour|
        # create a palette for a single colour from the providing mapping
        if method == 'absolutes'
          generated_swatches = UtilityPalettes::Swatch.absolute_generator(label, base_colour, @config.dig(:method), @increment_steppers)
        elsif method == 'relatives'
          generated_swatches = UtilityPalettes::Swatch.relative_generator(label, base_colour, @config.dig(:method), @increment_steppers)
        end

        # merge the colours absolute palette into the collective mapping
        looped_generated_palettes = {}.merge(looped_generated_palettes, generated_swatches)
      end

      looped_generated_palettes
    end

    def self.format_palette(palettes)
      palettes.compact_blank!

      palettes.transform_keys!(&:to_s)
      palettes.transform_keys! { |key| @config.dig(:output, :prefix) + key } if @config.dig(:output, :prefix).present?
      palettes.transform_keys! { |key| key + @config.dig(:output, :suffix) } if @config.dig(:output, :suffix).present?

      palettes
    end
  end
end
