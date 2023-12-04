def test_input_day04
  [
    "Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53",
    "Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19",
    "Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1",
    "Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83",
    "Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36",
    "Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11",
  ]
end

def input_day04
  File.read('day04.txt').chomp.split("\n")
end

def parse_input cards
  cards.map do |card|
    card_hash = {}
    card_hash[:id] = card.split(': ')[0].scan(/\d/).join('').to_i
    card_hash[:numbers] = card.split(': ')[1].split(' | ').map { |numbers| numbers.split(' ').map(&:to_i) }
    card_hash[:matches] = new_array_for_matches(card_hash[:numbers])
    card_hash[:points] = calculate_points_per_card(card_hash)
    card_hash
  end
end

def new_array_for_matches card
  numbers_to_match = card[0]
  numbers_you_have = card[1]

  # Intersection?
  numbers_to_match & numbers_you_have
end

def calculate_points_per_card card
  points = 0
  card[:matches].each_with_index do |match, index|
    if index == 0
      points += 1
    end

    if index > 0
      points *= 2
    end
  end
  points
end

def sum_of_points cards
  parsed_cards = parse_input cards
  "Total Points of All the Cards is: #{parsed_cards.map { |card| card[:points] }.sum}"
end

puts sum_of_points input_day04
