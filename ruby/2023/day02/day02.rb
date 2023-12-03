def day02_test_input_1
  [
    "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green",
    "Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue",
    "Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red",
    "Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red",
    "Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green",
  ]
end

def day02_input
  File.read('day02.txt').chomp.split("\n")
end

def parseColor(color, line)
  line.scan(/\d+ #{color}/).join('').scan(/\d+/).map(&:to_i)
end

def parsedInput(input)
  input.map do |line|
    lineHash = createHash(line)
    lineHash[:possible] = checkIfGameIsPossible(lineHash)
    lineHash
  end
end

def maxPossibleCubes
  {
    red: 12,
    green: 13,
    blue: 14,
  }
end

def checkIfGameIsPossible(game)
  if game[:red] > maxPossibleCubes[:red] ||
     game[:green] > maxPossibleCubes[:green] ||
     game[:blue] > maxPossibleCubes[:blue]
    return false
  end

  true
end

def createHash(line)
  lineHash = {}

  lineHash[:id] = line.split(': ')[0].scan(/\d/).join('').to_i

  lineHash[:blue] = parseColor("blue", line).max
  lineHash[:red] = parseColor("red", line).max
  lineHash[:green] = parseColor("green", line).max

  lineHash
end

def sumOfPossibleGames(games)
  games.select { |game| game[:possible] == true }.map { |game| game[:id] }.sum
end

puts "The sume of the IDs of the games that are possible is: #{sumOfPossibleGames(parsedInput(day02_input))}"

