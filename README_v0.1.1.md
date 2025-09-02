# UtilityPalettes

> Generate your own colour palettes in an instance.

Utility Palettes is an ruby gem package for use in ruby or other projects that generates palettes and shades based on supplied colours.
Take a single colour and generate a full tailwind-style set of "absolute" shades ranging from -50 to -900 where the given colour is inserted into the range where it suits best.
Or generate "relative" shades that have the supplied colour at it's core and add a -light and -dark shade.

## Installation

Install the gem and add to the application's Gemfile by executing:

```bash
bundle add utility_palettes
```

If bundler is not being used to manage dependencies, install the gem by executing:

```bash
gem install utility_palettes
```

## Usage

To get the config full of

```bash
rails generate utility_palettes:config
```

to generate the palettes

```bash
rails generate utility_palettes:generate
```

### Environment

Set the environment that the sub-data will be read in, meaning that the palette generator can only be run in certain environments.

### Defaults

Should the default colours be included for the palette generator. Even if they are included, they can be overwritten by the user's own colour of the same name:

| Option     | Default | Possible Values |
| :--------- | :-----: | :-------------: |
| absolutes  | true    | true / false    |
| relatives  | true    | true / false    |
| singles    | true    | true / false    |

### Output

How the output file and values should be written:

| Option  | Description                                                                             | Default | Possible Values                                         |
| :------ | :-------------------------------------------------------------------------------------- | :-----: | :-----------------------------------------------------: |
| dated   | Should a timestamp be included in the filenames                                         | false   | true / false                                            |
| files   | The types of files the palette should be output in, written as a comma separated string | json    | json, scss, css                                         |
| format  | The colour syntax the output colours should be written in                               | rgb     | rgb, hsl, hsv, hsb, cmyk, cielab, lab, cielch, lch, hex |
| prefix  | A string that is appended to the start of all colour names, i.e. 'tw-'                  | ''      | <any string>                                            |
| suffix  | A string that is appended to the end of all colour names, i.e. '-col'                   | ''      | <any string>                                            |

The JSON output file will appear at the top-level of your project, while SCSS and CSS are defined to go to `app/assets/stylesheets`.

### Method (WIP)

It allos you to determine how you want the colours to be adjusted to create the variance in your palette, but for now all colour adjustments are made by changing the HSL values as it is the best combination of the simple yet effective and accurate method available.
In the future you will be able to shift the colours by changing values for different colour models and colour spaces; like RGB, CieLAB, OkLCH and others.

### Steps (WIP)

Defines the percentage you want each colour to be adjusted by when moving through the colour palette. For now all steps are for the HSL method of adjusting colours
In the future you will be able to shift the colours by changing values for different colour models and colour spaces; like RGB, CieLAB, OkLCH and others.

| Option  | Description                          | Default | Possible Values |
| :------ | :----------------------------------: | :-----: | :-------------: |
| h       | How much to adjust the hue by        | 0       | 0 - 100         |
| s       | How much to adjust the saturation by | 2       | 0 - 100         |
| l       | How much to adjust the lightness by  | 9       | 0 - 100         |

### Absolutes

Here you would define colour names and values that you would like to create an "absolute palette"; where for each colour given, a range of colours are output with -50, -100, ..., -900 suffixes using that colour as the base.

### Relatives

Here you would define colour names and values that you would like to create an "relative palette"; where for each colour given, a -light and -dark colour are generated one step up and down from the base colour.
If a colour is included in both the "absolutes" and "relatives" sections, then the -light and -dark colours will match with colours in the absolute palette.

### Singles

Here you would define colour names and values that you would like copied directly to the output as you have defined them.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at <https://github.com/louiswdavis/utility_palettes>. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/louiswdavis/utility_palettes/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the UtilityPalettes project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/louiswdavis/utility_palettes/blob/master/CODE_OF_CONDUCT.md).
