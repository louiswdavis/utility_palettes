# frozen_string_literal: true

module UtilityPalettes
  class Outputs
    def self.generate(generated_palettes, config)
      output_format = config.dig(:output, :format).to_s.downcase.presence
      output_palettes = {}

      generated_palettes.each do |label, colourize_colour|
        case output_format
        when 'rgb'
          values = colourize_colour.rgb.values
        when 'hsl'
          values = colourize_colour.hsl.values
          values[1] = self.append_percentage(values[1])
          values[2] = self.append_percentage(values[2])
        when 'hsv'
          values = colourize_colour.hsv.values
          values[1] = self.append_percentage(values[1])
          values[2] = self.append_percentage(values[2])
        when 'hsb'
          values = colourize_colour.hsb.values
          values[1] = self.append_percentage(values[1])
          values[2] = self.append_percentage(values[2])
        when 'cmyk'
          values = colourize_colour.cmyk.values
          values[1] = self.append_percentage(values[1])
          values[2] = self.append_percentage(values[2])
          values[3] = self.append_percentage(values[3])
          output_format = 'device-cmyk'
        when 'cielab', 'lab'
          values = colourize_colour.cielab.values
          values[0] = self.append_percentage(values[0])
          output_format = 'lab'
        when 'cielch', 'lch'
          values = colourize_colour.cielch.values
          values[0] = self.append_percentage(values[0])
          output_format = 'lch'
        when 'hex'
          values = colourize_colour.hex
        else
          values = colourize_colour.rgb.values
          output_format = 'rgb'
        end

        case output_format
        when 'hex'
          values += (colourize_colour.alpha * 255).round.to_s(16).slice(0, 2).upcase if colourize_colour.alpha < 1.0
          output_palettes[label] = values
        else
          values << self.append_alpha(colourize_colour.alpha) if colourize_colour.alpha < 1.0
          output_palettes[label] = "#{output_format}(#{values.join(' ')})"
        end
      end

      output_palettes
    end

    def self.json(filename, output_palettes)
      file = Tempfile.new([filename, '.json'])

      File.open(file, 'w') do |f|
        f.write(JSON.pretty_generate(output_palettes))
      end

      puts 'Exporting utility palettes JSON...'
      file
    end

    def self.scss(filename, output_palettes)
      file = Tempfile.new([filename, '.scss'])

      File.open(file, 'w') do |f|
        f.write(output_palettes.collect { |label, hex| "$#{label}: #{hex};" }.join("\n"))
      end

      puts 'Exporting utility palettes SCSS...'
      file
    end

    def self.css(filename, output_palettes)
      file = Tempfile.new([filename, '.css'])

      File.open(file, 'w') do |f|
        f.write(":root {\n\t#{output_palettes.collect { |label, hex| "--#{label}: #{hex};" }.join("\n\t")}\n}")
      end

      puts 'Exporting utility palettes CSS...'
      file
    end

    def bespoke_property_variables
      # const utilities = {
      #   bg: (value) => ({ 'background-color': value }),
      #   text: (value) => ({ 'color': value }),
      #   border: (value) => ({ 'border-color': value }),
      #   'border-t': (value) => ({ '--tw-border-opacity': 1, 'border-top-color': value }),
      #   'border-r': (value) => ({ '--tw-border-opacity': 1, 'border-right-color': value }),
      #   'border-b': (value) => ({ '--tw-border-opacity': 1, 'border-bottom-color': value }),
      #   'border-l': (value) => ({ '--tw-border-opacity': 1, 'border-left-color': value }),
      #   outline: (value) => ({ 'outline-color': value }),
      #   ring: (value) => ({ '--tw-ring-opacity': 1, '--tw-ring-color': value }),
      #   'ring-offset': (value) => ({ '--tw-ring-offset-color': value }),
      #   'shadow': (value) => ({ '--tw-shadow-color': value, '--tw-shadow': 'var(--tw-shadow-colored)' }),
      #   accent: (value) => ({ 'accent-color': value }),
      #   caret: (value) => ({ 'caret-color': value }),
      #   fill: (value) => ({ 'fill': value }),
      #   stroke: (value) => ({ 'stroke': value }),
      # };
    end

    private

    def self.append_percentage(value)
      "#{value}%"
    end

    def self.append_alpha(alpha)
      "/ #{alpha * 100}"
    end
  end
end
