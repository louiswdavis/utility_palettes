
module UtilityPalettesRails
  class Outputs
    def self.json(filename, output_palettes)
      File.open("#{filename}.json", 'w') do |f|
        f.write(JSON.pretty_generate(output_palettes))
      end

      puts 'Exported utility palettes JSON...'
    end
    
    def self.scss(filename, output_palettes)
      File.open("app/assets/stylesheets/#{filename}.scss", 'w') do |f|
        f.write(output_palettes.collect { |label, hex| "$#{label}: #{hex};" }.join("\n"))
      end

      puts 'Exported utility palettes SCSS...'
    end
    
    def self.css(filename, output_palettes)
      File.open("app/assets/stylesheets/#{filename}.css", 'w') do |f|
        f.write(":root {\n\t" + output_palettes.collect { |label, hex| "--#{label}: #{hex};" }.join("\n\t") + "\n}")
      end

      puts 'Exported utility palettes CSS...'
    end
  end
end