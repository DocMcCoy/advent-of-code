require "rspec/autorun"

RSpec.configure do |config|
  config.formatter = :documentation
end

class Table
  attr_accessor :input, :scratchcards_hash

  def initialize input
    @input             = input
    @scratchcards_hash = {}
  end

  def input_array
    @input.chomp.split("\n")
  end

  def cards_array
    input_array.map do |card|
      new_card = Card.new(card)

      new_card
    end
  end

  def card_ids
    cards_array.map do |card|
      card.id
    end
  end

  def matches
    cards_array.map do |card|
      card.matches
    end
  end

  def points
    cards_array.map do |card|
      card.points
    end
  end

  def total_points
    points.sum
  end

  def create_scratchcards_hash_map
    cards_array.each_with_index do |card, index|
      scratchcards_hash[index] = scratchcards_hash[index] || 1

      card.cards_to_increment.times do |i|
        index_to_increment = index + i + 1
        scratchcards_hash[index_to_increment] = (scratchcards_hash[index_to_increment] || 1) + scratchcards_hash[index]
      end
    end
  end

  def total_scratchcards
    create_scratchcards_hash_map

    scratchcards_hash.values.sum
  end

  def part_one
    "The total points is #{total_points}"
  end

  def part_two
    "The total scratchcards is #{total_scratchcards}"
  end
end

class Card
  attr_accessor :input, :quantity

  def initialize input
    @input = input
    @starting_quantity = 1
  end

  def id
    @input.split(': ')[0].scan(/\d/).join('').to_i
  end

  def numbers
    @input.split(': ')[1].split(' | ').map { |numbers| numbers.split(' ').map(&:to_i) }
  end

  def winning_numbers
    numbers[0]
  end

  def card_numbers
    numbers[1]
  end

  def matches
    card_numbers & winning_numbers
  end

  def sorted_matches
    matches.sort
  end

  def cards_per_id
    matches.length
  end

  def cards_to_increment
    matches.length
  end

  def points
    points = 0
    matches.each_with_index do |match, index|
      if index == 0
        points += 1
      end

      if index > 0
        points *= 2
      end
    end
    points
  end

  def quantity
    @quantity ||= @starting_quantity
  end
end

describe "Day Four:" do
  let(:full_example) {
    <<~EOTEXT
      Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
      Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
      Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
      Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
      Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
      Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
    EOTEXT
  }
  let(:card_example_line_one) { "Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53" }

  describe "test inputs should match" do
    it "boop" do
      expect(full_example.split("\n")[0]).to eq("Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53")
    end
  end

  describe Table do
    let(:table) { Table.new(full_example) }

    describe "when initialized the Table class" do
      it "should return the input" do
        expect(table.input).to eq(full_example)
      end
    end

    describe "input_array method" do
      it "should respond" do
        expect(table).to respond_to(:input_array)
      end

      it "should return an array" do
        expect(table.input_array).to be_an_instance_of(Array)
      end

      it "should return an array of the input by line" do
        expect(table.input_array)
          .to eq(
            [
              "Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53",
              "Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19",
              "Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1",
              "Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83",
              "Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36",
              "Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11"
            ]
          )
      end
    end

    describe "the cards_array method" do
      it "should respond" do
        expect(table).to respond_to(:cards_array)
      end

      it "with an array" do
        expect(table.cards_array).to be_an_instance_of(Array)
      end

      it "and the first card should being an instance of the Card class" do
        expect(table.cards_array[0]).to be_an_instance_of(Card)
      end
    end

    describe "card_ids method" do
      it "should respond" do
        expect(table).to respond_to(:card_ids)
      end

      it "with an array" do
        expect(table.card_ids).to be_an_instance_of(Array)
      end

      it "and it should be equal to [1, 2, 3, 4, 5, 6]" do
        expect(table.card_ids).to eq([1, 2, 3, 4, 5, 6])
      end
    end

    describe "matches method" do
      it "should respond" do
        expect(table).to respond_to(:matches)
      end

      it "with an array" do
        expect(table.matches).to be_an_instance_of(Array)
      end

      it "and it should be equal to [[83, 86, 17, 48], [61, 32], [21, 1], [84], [], []]" do
        expect(table.matches).to eq([[83, 86, 17, 48], [61, 32], [21, 1], [84], [], []])
      end
    end

    describe "points method" do
      it "should respond" do
        expect(table).to respond_to(:points)
      end

      it "with an array" do
        expect(table.points).to be_an_instance_of(Array)
      end

      it "and it should be equal to [8, 2, 2, 1, 0, 0]" do
        expect(table.points).to eq([8, 2, 2, 1, 0, 0])
      end
    end

    describe "total_points method" do
      it "should respond" do
        expect(table).to respond_to(:total_points)
      end

      it "should return the sum of all the points" do
        expect(table.total_points).to eq(13)
      end
    end

    describe "total_scratchcards method" do
      it "should respond" do
        expect(table).to respond_to(:total_scratchcards)
      end

      it "with an integer" do
        expect(table.total_scratchcards).to be_an_instance_of(Integer)
      end

      it "and be equal to 30" do
        expect(table.total_scratchcards).to eq(30)
      end
    end
  end

  describe Card do
    let(:card) { Card.new(card_example_line_one) }

    describe "when initialized" do
      it "should be an instance of the Card class" do
        expect(card).to be_an_instance_of(Card)
      end

      it "should return the input" do
        expect(card.input).to eq(card_example_line_one)
      end
    end

    describe "id method" do
      it "should respond" do
        expect(card).to respond_to(:id)
      end

      it "with an integer" do
        expect(card.id).to be_an_instance_of(Integer)
      end

      it "and equal 1" do
        expect(card.id).to eq(1)
      end
    end

    describe "numbers method" do
      it "should respond" do
        expect(card).to respond_to(:numbers)
      end

      it "with an array" do
        expect(card.numbers).to be_an_instance_of(Array)
      end

      it "and equal [[41, 48, 83, 86, 17], [83, 86, 6, 31, 17, 9, 48, 53]]" do
        expect(card.numbers).to eq([[41, 48, 83, 86, 17], [83, 86, 6, 31, 17, 9, 48, 53]])
      end
    end

    describe "winning_numbers method" do
      it "should respond" do
        expect(card).to respond_to(:winning_numbers)
      end

      it "with an array" do
        expect(card.winning_numbers).to be_an_instance_of(Array)
      end

      it "and equal [41, 48, 83, 86, 17]" do
        expect(card.winning_numbers).to eq([41, 48, 83, 86, 17])
      end
    end

    describe "card_numbers method" do
      it "should respond" do
        expect(card).to respond_to(:card_numbers)
      end

      it "with an array" do
        expect(card.card_numbers).to be_an_instance_of(Array)
      end

      it "and equal [83, 86, 6, 31, 17, 9, 48, 53]" do
        expect(card.card_numbers).to eq([83, 86, 6, 31, 17, 9, 48, 53])
      end
    end

    describe "matches method" do
      it "should respond" do
        expect(card).to respond_to(:matches)
      end

      it "with an array" do
        expect(card.matches).to be_an_instance_of(Array)
      end

      it "and equal [83, 86, 17, 48]" do
        expect(card.matches).to eq([83, 86, 17, 48])
      end
    end

    describe "sorted_matches method" do
      it "should respond" do
        expect(card).to respond_to(:sorted_matches)
      end

      it "with an array" do
        expect(card.sorted_matches).to be_an_instance_of(Array)
      end

      it "and equal [17, 48, 83, 86]" do
        expect(card.sorted_matches).to eq([17, 48, 83, 86])
      end
    end

    describe "points method" do
      it "should respond" do
        expect(card).to respond_to(:points)
      end

      it "with an integer" do
        expect(card.points).to be_an_instance_of(Integer)
      end

      it "and equal 8" do
        expect(card.points).to eq(8)
      end
    end

    describe "quantity" do
      it "should respond" do
        expect(card).to respond_to(:quantity)
      end

      it "with an integer" do
        expect(card.quantity).to be_an_instance_of(Integer)
      end

      it "and equal 1" do
        expect(card.quantity).to eq(1)
      end

      it "will increment by the quantity provided (1 then 2) equalling 2 and 4" do
        card.quantity = 2
        expect(card.quantity).to eq(2)
        card.quantity = card.quantity + 2
        expect(card.quantity).to eq(4)
      end
    end
  end

  describe "Part One" do
    it do
      if ARGF.filename != "-" || (! STDIN.tty? && ! STDIN.closed?)
        puts "    #{Table.new(File.read(ARGF.filename)).part_one}"
      else
        puts "    TestInput: #{Table.new(full_example).part_one}"
      end
    end
  end

  describe "Part Two" do
    it do
      if ARGF.filename != "-" || (! STDIN.tty? && ! STDIN.closed?)
        puts "    #{Table.new(File.read(ARGF.filename)).part_two}"
      else
        puts "    TestInput: #{Table.new(full_example).part_two}"
      end
    end
  end
end

if ARGF.filename != "-" || (! STDIN.tty? && ! STDIN.closed?)
  # puts input ARGF.filename
  # CODE TO RUN GOES HERE. ruby <this-file> <data-file>
  todays_input = File.read(ARGF.filename)
end
