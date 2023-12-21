require "rspec/autorun"

RSpec.configure do |config|
  config.formatter = :documentation
end

class Almanac
  attr_accessor :input

  def initialize input
    @input = input
  end

  def seeds
    seeds_text = @input.chomp.split("\n\n")[0]
    Seeds.new(seeds_text).parsed_input
  end

  def number_of_maps
    @input.chomp.split("\n\n").length - 1
  end

  def location_numbers
    source_numbers = seeds
    destination_numbers = []

    number_of_maps.times do |i|
      map_text = @input.chomp.split("\n\n")[i + 1]
      map      = AlmanacMap.new(map_text, source_numbers)
      destination_numbers = map.destination_numbers
      source_numbers = destination_numbers
    end
    destination_numbers
  end

  def lowest_location_number
    location_numbers.min
  end
end

class Seeds
  attr_accessor :input

  def initialize input
    @input = input
  end

  def parsed_input
    @input.chomp.split(": ")[1].split(" ").map(&:to_i)
  end

  def seed_ranges
    parsed_input.each_slice(2).to_a.map do |slice|
      slice[0]..(slice[0] + slice[1])
    end
  end
end

class AlmanacMap
  attr_accessor :map_text, :input

  def initialize map_text, input = []
    @map_text = map_text
    @input    = input
  end

  def name
    @map_text.chomp.split(" map:")[0]
  end

  def parsed_map_text
    @map_text.chomp.split(" map:\n")[1].split("\n").map do |line|
      line.split(" ").map(&:to_i)
    end
  end

  def destination_numbers
    source_numbers      = @input
    destination_numbers = []

    source_numbers.each do |source_number|
      parsed_map_text.each do |row|
        destination_range = row[0]
        source_range      = row[1]
        range_length      = row[2]

        if source_number >= source_range && source_number <= source_range + range_length
          offset = source_number - source_range
          destination_numbers << destination_range + offset
          break
        else
          if parsed_map_text.last == row
            destination_numbers << source_number
          end
        end
      end
    end
    destination_numbers
  end
end

describe "Day 5: Almanac" do
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
  let(:seeds_example) {
    <<~EOTEXT
      seeds: 79 14 55 13
    EOTEXT
  }
  let(:almanac_map_example) {
    <<~EOTEXT
      fertilizer-to-water map:
      49 53 8
      0 11 42
      42 0 7
      57 7 4
    EOTEXT
  }

  let(:almanac) { Almanac.new(full_example) }
  let(:seeds) { Seeds.new(seeds_example) }
  let(:almanac_map) { AlmanacMap.new(almanac_map_example, [81, 53, 57, 52]) }

  describe Almanac do

    describe "when initialized" do
      it "should be an instance of the Almanac class" do
        expect(almanac).to be_an_instance_of(Almanac)
      end

      it "should return the input" do
        expect(almanac.input).to eq(full_example)
      end
    end

    describe "seeds method" do
      it "should respond" do
        expect(almanac).to respond_to(:seeds)
      end

      it "should return an array" do
        expect(almanac.seeds).to be_an_instance_of(Array)
      end

      it "and should return the seeds equal to [79, 14, 55, 13]" do
        expect(almanac.seeds).to eq([79, 14, 55, 13])
      end
    end

    describe "number_of_maps method" do
      it "should respond" do
        expect(almanac).to respond_to(:number_of_maps)
      end

      it "should return an integer" do
        expect(almanac.number_of_maps).to be_an_instance_of(Integer)
      end

      it "should return the number of maps" do
        expect(almanac.number_of_maps).to eq(7)
      end
    end

    describe "location_numbers method" do
      it "should respond" do
        expect(almanac).to respond_to(:location_numbers)
      end

      it "should return an array" do
        expect(almanac.location_numbers).to be_an_instance_of(Array)
      end

      it "should return the location numbers" do
        expect(almanac.location_numbers).to eq([82, 43, 86, 35])
      end
    end

    describe "lowest_location_number method" do
      it "should respond" do
        expect(almanac).to respond_to(:lowest_location_number)
      end

      it "should return an integer" do
        expect(almanac.lowest_location_number).to be_an_instance_of(Integer)
      end

      it "should return the lowest location number" do
        expect(almanac.lowest_location_number).to eq(35)
      end
    end
  end

  describe Seeds do
    describe "when initialized" do
      it "should be an instance of the Seeds class" do
        expect(seeds).to be_an_instance_of(Seeds)
      end

      it "should return the input" do
        expect(seeds.input).to eq(seeds_example)
      end
    end

    describe "parse_input method" do
      it "should respond" do
        expect(seeds).to respond_to(:parsed_input)
      end

      it "should return an array" do
        expect(seeds.parsed_input).to be_an_instance_of(Array)
      end

      it "should return an array of the seeds" do
        expect(seeds.parsed_input).to eq([79, 14, 55, 13])
      end
    end

    describe "seed_ranges method" do
      it "should respond" do
        expect(seeds).to respond_to(:seed_ranges)
      end

      it "should return an array" do
        expect(seeds.seed_ranges).to be_an_instance_of(Array)
      end

      it "should return an array of the seed range" do
        expect(seeds.seed_ranges).to eq([79..93, 55..68])
      end
    end
  end

  describe AlmanacMap do

    describe "when initialized" do
      it "should be an instance of the AlmanacMap class" do
        expect(almanac_map).to be_an_instance_of(AlmanacMap)
      end

      it "should return the input" do
        expect(almanac_map.map_text).to eq(almanac_map_example)
      end
    end

    describe "name method" do
      it "should respond" do
        expect(almanac_map).to respond_to(:name)
      end

      it "should return the name of the map" do
        expect(almanac_map.name).to eq("fertilizer-to-water")
      end
    end

    describe "parsed_input method" do
      it "should respond" do
        expect(almanac_map).to respond_to(:parsed_map_text)
      end

      it "should return an array" do
        expect(almanac_map.parsed_map_text).to be_an_instance_of(Array)
      end

      it "should return an array of the ranges" do
        expect(almanac_map.parsed_map_text).to eq([[49, 53, 8], [0, 11, 42], [42, 0, 7], [57, 7, 4]])
      end
    end

    describe "destination_numbers method" do
      it "should respond" do
        expect(almanac_map).to respond_to(:destination_numbers)
      end

      it "should return an array" do
        expect(almanac_map.destination_numbers).to be_an_instance_of(Array)
      end

      it "should return an array of the destination numbers" do
        expect(almanac_map.destination_numbers).to eq([81, 49, 53, 41])
      end
    end
  end
end

if ARGF.filename != "-" || (! STDIN.tty? && ! STDIN.closed?)
  # puts input ARGF.filename

  testing = Almanac.new File.read(ARGF.filename)
  # CODE TO RUN GOES HERE. ruby <this-file> <data-file>

  puts testing.lowest_location_number
end
