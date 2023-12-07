require "rspec/autorun"

RSpec.configure do |config|
  config.formatter = :documentation
end

class Almanac
  def initialize input
    @input = input.chomp.split("\n\n")
  end

  def seeds input = @input
    Seeds.new(input[0]).output
  end

  def seeds_to_soil_map input = @input
    Maps.new(@input[1]).parse_input
  end

  def soil_number
    seeds.map do |seed_number|
      map = Maps.new(@input[1]).output
      soil_number = map[seed_number] || seed_number
    end
  end

  def soil_to_fertilizer_map
    Maps.new(@input[2]).parse_input
  end

  def fertilizer_number
    soil_number.map do |soil_number|
      map = Maps.new(@input[2]).output
      fertilizer_number = map[soil_number] || soil_number
    end
  end

  def fertilizer_to_water_map
    Maps.new(@input[3]).parse_input
  end

  def water_number
    puts Maps.new(@input[3]).output
    fertilizer_number.map do |fertilizer_number|
      map = Maps.new(@input[3]).output

      water_number = map[fertilizer_number] || fertilizer_number
      puts "water_number: #{water_number}, fertilizer_number: #{fertilizer_number}"
    end
  end

  def water_to_light_map
    Maps.new(@input[4]).parse_input
  end

  def light_to_temperature_map
    Maps.new(@input[5]).parse_input
  end

  def temperature_to_humidity_map
    Maps.new(@input[6]).parse_input
  end

  def humidity_to_location_map
    Maps.new(@input[7]).parse_input
  end
end

class Maps
  def initialize input
    @input = input
  end

  def parse_input
    @input.split(":\n")[1].split("\n").map { |row| row.split(" ").map(&:to_i) }
  end

  def output
    hash_map = {}

    parse_input.each do |row|
      destination_range_start = row[0]
      source_range_start      = row[1]
      range_length            = row[2]
      offset                  = (source_range_start - destination_range_start)
      for i in destination_range_start..range_length + destination_range_start
        source_number = i + offset
        hash_map[source_number] = i
      end
      puts "hash_map: #{hash_map}"
    end

    hash_map
  end
end

class Seeds
  def initialize input
    @input = input
  end

  def output
    @input.split(": ")[1].split(" ").map(&:to_i)
  end
end

describe Almanac do
  let(:full_example) {
    <<~EOTEXT
      seeds: 79 14 55 13

      seed-to-soil map:
      50 98 2
      52 50 48

      soil-to-fertilizer map:
      0 15 37
      37 52 2
      39 0 15

      fertilizer-to-water map:
      49 53 8
      0 11 42
      42 0 7
      57 7 4

      water-to-light map:
      88 18 7
      18 25 70

      light-to-temperature map:
      45 77 23
      81 45 19
      68 64 13

      temperature-to-humidity map:
      0 69 1
      1 0 69

      humidity-to-location map:
      60 56 37
      56 93 4
    EOTEXT
  }

  let(:almanac) { Almanac.new(full_example) }

  it "should initialize the Almanac class" do
    expect(almanac).to be_an_instance_of(Almanac)
  end

  it "should return the seeds" do
    expect(almanac.seeds).to eq([79, 14, 55, 13])
  end

  it "should return the seeds to soil map" do
    expect(almanac.seeds_to_soil_map).to eq([[50, 98, 2], [52, 50, 48]])
  end

  it "should return the soil to fertilizer map" do
    expect(almanac.soil_to_fertilizer_map).to eq([[0, 15, 37], [37, 52, 2], [39, 0, 15]])
  end

  it "should return the fertilizer to water map" do
    expect(almanac.fertilizer_to_water_map).to eq([[49, 53, 8], [0, 11, 42], [42, 0, 7], [57, 7, 4]])
  end

  it "should return the water to light map" do
    expect(almanac.water_to_light_map).to eq([[88, 18, 7], [18, 25, 70]])
  end

  it "should return the light to temperature map" do
    expect(almanac.light_to_temperature_map).to eq([[45, 77, 23], [81, 45, 19], [68, 64, 13]])
  end

  it "should return the temperature to humidity map" do
    expect(almanac.temperature_to_humidity_map).to eq([[0, 69, 1], [1, 0, 69]])
  end

  it "should return the humidity to location map" do
    expect(almanac.humidity_to_location_map).to eq([[60, 56, 37], [56, 93, 4]])
  end

  it "should return the seed to the correct soil" do
    expect(almanac.soil_number).to eq([81, 14, 57, 13])
  end

  it "should return the seed to the correct fertilizer" do
    expect(almanac.fertilizer_number).to eq([81, 53, 57, 52])
  end

  it "should return the seed to the correct water" do
    expect(almanac.water_number).to eq([81, 49, 53, 41])
  end
end

if ARGF.filename != "-" || (! STDIN.tty? && ! STDIN.closed?)
  # puts input ARGF.filename

  testing = Almanac.new File.read(ARGF.filename)
  # CODE TO RUN GOES HERE. ruby <this-file> <data-file>
  puts testing.soil_number
end
