module UtilityPalettes
  module Generators
    class GenerateGenerator < Rails::Generators::Base
      def generate_utility_palettes
        puts 'Generating utility palettes...'

        if File.exist?('config/utility_palettes.yml') && defined?(Rails.application.config_for)
          @config = Rails.application.config_for(:utility_palettes).dig('utility_palettes') || {}
        else
          @config = JSON.parse(File.read('config/utility_palettes.json')) || {}
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

        converted_absolutes = self.colorize_values(combined_absolutes)
        converted_relatives = self.colorize_values(combined_relatives)
        converted_singles = self.colorize_values(combined_singles)

        puts 'Converted palettes...'

        generated_absolutes = self.palette_looper(converted_absolutes, 'absolutes')
        generated_relatives = self.palette_looper(converted_relatives, 'relatives')
        generated_singles = converted_singles

        puts 'Generated utility palettes...'

        generated_palettes = {}.merge(generated_absolutes, generated_relatives, generated_singles);
        output_palettes = self.generate_output(generated_palettes).compact_blank!

        output_palettes.transform_keys!(&:to_s)
        output_palettes.transform_keys! { |key| @config.dig(:output, :prefix) + key } if @config.dig(:output, :prefix).present?
        output_palettes.transform_keys! { |key| key + @config.dig(:output, :suffix) } if @config.dig(:output, :suffix).present?

        filename = 'utility_palettes'
        filename += '-' + Time.zone.now.strftime('%Y%m%d-%H%M%S') if @config.dig(:output, :dated) == true

        if @config.dig(:output, :files).blank? || @config.dig(:output, :files).split(',').include?('json')
          File.open("#{filename}.json", 'w') do |f|
            f.write(JSON.pretty_generate(output_palettes))
          end

          puts 'Exported utility palettes JSON...'
        end

        if @config.dig(:output, :files).split(',').include?('scss')
          File.open("app/assets/stylesheets/#{filename}.scss", 'w') do |f|
            f.write(output_palettes.collect { |label, hex| "$#{label}: #{hex};" }.join("\n"))
          end

          puts 'Exported utility palettes SCSS...'
        end
      end

      private

      def colorize_values(color_hash)
        colorized_hash = {}

        color_hash.each do |label, color|
          if color.start_with?('$')
            # if the color label begins with $ then it is a reference to a different defined color, so must be looked up in the main
            colorized_hash[label] = ColorConversion::Color.new(@combined_samples.dig(color[1..-1].to_sym))
          else
            colorized_hash[label] = ColorConversion::Color.new(color)
          end
        rescue ColorConversion::InvalidColorError => e
          STDERR.puts "Error processing color #{label} with value #{color}: #{e.message}"
        end

        colorized_hash
      end

      # * Palettes

      # ? Multiple Colour's Palette
      # a function to loop through a map of colours and create absolute or relative palettes for them all and collect this into a single map

      def palette_looper(color_map, method)
        looped_generated_palettes = {}

        color_map.each do |label, base_color|
          # create a palette for a single colour from the providing mapping
          if method == 'absolutes'
            generated_swatches = UtilityPalettesRails::Swatch.absolute_generator(label, base_color, @config.dig(:method), @sequence_steps)
          elsif method == 'relatives'
            generated_swatches = UtilityPalettesRails::Swatch.relative_generator(label, base_color, @config.dig(:method), @sequence_steps)
          end

          # merge the colours absolute palette into the collective mapping
          looped_generated_palettes = {}.merge(looped_generated_palettes, generated_swatches)
        end

        looped_generated_palettes
      end

      def generate_output(generated_palettes)
        output_palettes = {}

        generated_palettes.each do |label, colorize_color|
          case @config.dig(:output, :format)
          when 'rgb'
            value = colorize_color.rgb
            value[:a] = self.append_alpha(colorize_color.alpha) if colorize_color.alpha < 1.0
            output_palettes[label] = "#{value.keys.join('')}(#{value.values.join(', ')})"
          when 'hsl'
            value = colorize_color.hsl
            value[:s] = self.append_percentage(value[:s])
            value[:l] = self.append_percentage(value[:l])
            value[:a] = self.append_alpha(colorize_color.alpha) if colorize_color.alpha < 1.0
            output_palettes[label] = "#{value.keys.join('')}(#{value.values.join(' ')})"
          when 'hsv'
            value = colorize_color.hsv
            value[:s] = self.append_percentage(value[:s])
            value[:v] = self.append_percentage(value[:v])
            value[:a] = self.append_alpha(colorize_color.alpha) if colorize_color.alpha < 1.0
            output_palettes[label] = "#{value.keys.join('')}(#{value.values.join(', ')})"
          when 'hsb'
            value = colorize_color.hsb
            value[:s] = self.append_percentage(value[:b])
            value[:b] = self.append_percentage(value[:l])
            value[:a] = self.append_alpha(colorize_color.alpha) if colorize_color.alpha < 1.0
            output_palettes[label] = "#{value.keys.join('')}(#{value.values.join(', ')})"
          when 'cmyk'
            value = colorize_color.cmyk
            value[:a] = self.append_alpha(colorize_color.alpha) if colorize_color.alpha < 1.0
            output_palettes[label] = "#{value.keys.join('')}(#{value.values.join(', ')})"
          when 'hex'
            value = colorize_color.hex
            value += (colorize_color.alpha * 255).round.to_s(16).slice(0, 2).upcase if colorize_color.alpha < 1.0
            output_palettes[label] = value
          else
            value = colorize_color.hex
            value += (colorize_color.alpha * 255).round.to_s(16).slice(0, 2).upcase if colorize_color.alpha < 1.0
            output_palettes[label] = value
          end
        end

        output_palettes.to_a.reverse.to_h.uniq { |k, v| k.to_s }.to_h.sort_by { |k, v| k.to_s }.to_h
      end

      def adjust_output_naming
        
        
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