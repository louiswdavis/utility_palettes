module UtilityPalettes
  module Generators
    class GenerateGenerator < Rails::Generators::Base
      def generate_utility_palettes
        puts 'Generating utility palettes...'

        if File.exist?('config/utility_palettes.yml') && defined?(Rails.application.config_for)
          @config = Rails.application.config_for(:utility_palettes).dig('utility_palettes') || {}
        elsif File.exist?('config/utility_palettes.json')
          @config = JSON.parse(File.read('config/utility_palettes.json')).dig('utility_palettes') || {}
        else
          @config = {}
        end

        UtilityPalettesRails::Validations.validate_config(@config)
        @sequence_steps = UtilityPalettesRails::Configuration.setup(@config)

        puts 'Retrieved configuration...'

        default_absolutes = @config.dig(:defaults, :absolutes) == false ? [] : UtilityPalettesRails::Defaults.absolutes
        default_relatives = @config.dig(:defaults, :relatives) == false ? [] : UtilityPalettesRails::Defaults.relatives
        default_singles = @config.dig(:defaults, :singles) == false ? [] : UtilityPalettesRails::Defaults.singles

        puts 'Defined default palettes...'

        user_absolutes = @config.dig(:absolutes) || {}
        user_relatives = @config.dig(:relatives) || {}
        user_singles = @config.dig(:singles) || {}

        puts 'Retrieved user palettes...'

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

        generated_palettes = {}.merge(generated_absolutes, generated_relatives, generated_singles);
        generated_palettes = self.format_palette(generated_palettes)
        byebug
        output_palettes = self.generate_output(generated_palettes)
        byebug

        filename = 'utility_palettes'
        filename += '-' + Time.zone.now.strftime('%Y%m%d-%H%M%S') if @config.dig(:output, :dated) == true
        
        output_files = (@config.dig(:output, :files) || '').split(',').map(&:strip)

        UtilityPalettesRails::Outputs.json(filename, output_palettes) if output_files.blank? || output_files.include?('json')
        UtilityPalettesRails::Outputs.scss(filename, output_palettes) if output_files.include?('scss')
        UtilityPalettesRails::Outputs.css(filename, output_palettes) if output_files.include?('css')
      end

      private

      def colourize_values(colour_hash)
        colourized_hash = {}

        colour_hash.each do |label, colour|
          if colour.start_with?('$')
            # if the colour label begins with $ then it is a reference to a different defined colour, so must be looked up in the main
            colourized_hash[label] = ColorConversion::Color.new(@combined_samples.dig(colour[1..-1].to_sym))
          else
            colourized_hash[label] = ColorConversion::Color.new(colour)
          end

          # provide a name if the label is left blank
          if label == '$blank'
            hash[colourized_hash[label].name] = hash.delete(label)
            puts "Blank colour #{colour} has been given the name: #{colourized_hash[label].name}"
          end
        rescue ColorConversion::InvalidColorError => e
          STDERR.puts "Error processing colour #{label} with value #{colour}: #{e.message}"
        end

        colourized_hash
      end

      # * Palettes

      # ? Multiple Colour's Palette
      # a function to loop through a map of colours and create absolute or relative palettes for them all and collect this into a single map

      def palette_looper(colour_map, method)
        looped_generated_palettes = {}

        colour_map.each do |label, base_colour|
          # create a palette for a single colour from the providing mapping
          if method == 'absolutes'
            generated_swatches = UtilityPalettesRails::Swatch.absolute_generator(label, base_colour, @config.dig(:method), @sequence_steps)
          elsif method == 'relatives'
            generated_swatches = UtilityPalettesRails::Swatch.relative_generator(label, base_colour, @config.dig(:method), @sequence_steps)
          end

          # merge the colours absolute palette into the collective mapping
          looped_generated_palettes = {}.merge(looped_generated_palettes, generated_swatches)
        end

        looped_generated_palettes
      end

      def format_palette(generated_palettes)
        generated_palettes.compact_blank!
        
        # this will also remove duplicate keys
        generated_palettes.transform_keys!(&:to_s)
        
        # duplicate_keys = generated_palettes.keys.group_by(&:itself).transform_values(&:size).select { |k, v| v > 1 }.keys
        # puts "#{duplicate_keys.to_sentence} appear multiple times in the palette so are" if duplicate_keys.present?
        # remove duplicate keys in a way that the ?earliest? key is retained and the order of keys is kept
        # generated_palettes = generated_palettes.to_a.reverse.to_h.uniq { |k, v| k.to_s }.to_h.sort_by { |k, v| k.to_s }.to_h

        generated_palettes.transform_keys! { |key| @config.dig(:output, :prefix) + key } if @config.dig(:output, :prefix).present?
        generated_palettes.transform_keys! { |key| key + @config.dig(:output, :suffix) } if @config.dig(:output, :suffix).present?

        generated_palettes
      end

      def generate_output(generated_palettes)
        output_palettes = {}

        generated_palettes.each do |label, colourize_colour|
          case @config.dig(:output, :format)
          when 'rgb'
            value = colourize_colour.rgb
            value[:a] = self.append_alpha(colourize_colour.alpha) if colourize_colour.alpha < 1.0
            output_palettes[label] = "#{value.keys.join('')}(#{value.values.join(', ')})"
          when 'hsl'
            value = colourize_colour.hsl
            value[:s] = self.append_percentage(value[:s])
            value[:l] = self.append_percentage(value[:l])
            value[:a] = self.append_alpha(colourize_colour.alpha) if colourize_colour.alpha < 1.0
            output_palettes[label] = "#{value.keys.join('')}(#{value.values.join(' ')})"
          when 'hsv'
            value = colourize_colour.hsv
            value[:s] = self.append_percentage(value[:s])
            value[:v] = self.append_percentage(value[:v])
            value[:a] = self.append_alpha(colourize_colour.alpha) if colourize_colour.alpha < 1.0
            output_palettes[label] = "#{value.keys.join('')}(#{value.values.join(', ')})"
          when 'hsb'
            value = colourize_colour.hsb
            value[:s] = self.append_percentage(value[:b])
            value[:b] = self.append_percentage(value[:l])
            value[:a] = self.append_alpha(colourize_colour.alpha) if colourize_colour.alpha < 1.0
            output_palettes[label] = "#{value.keys.join('')}(#{value.values.join(', ')})"
          when 'cmyk'
            value = colourize_colour.cmyk
            value[:a] = self.append_alpha(colourize_colour.alpha) if colourize_colour.alpha < 1.0
            output_palettes[label] = "#{value.keys.join('')}(#{value.values.join(', ')})"
          when 'hex'
            value = colourize_colour.hex
            value += (colourize_colour.alpha * 255).round.to_s(16).slice(0, 2).upcase if colourize_colour.alpha < 1.0
            output_palettes[label] = value
          else
            value = colourize_colour.hex
            value += (colourize_colour.alpha * 255).round.to_s(16).slice(0, 2).upcase if colourize_colour.alpha < 1.0
            output_palettes[label] = value
          end
        end

        output_palettes
      end

      def append_percentage(value)
        value.to_s + '%'
      end

      def append_alpha(alpha)
        "/ #{alpha * 100}"
      end
    end
  end
end