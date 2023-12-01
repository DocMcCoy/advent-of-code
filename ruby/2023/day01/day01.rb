calibration = File.read('day01.txt').chomp.split("\n")

testInput1 = [
  "1abc2",
  "pqr3stu8vwx",
  "a1b2c3d4e5f",
  "treb7uchet",
]

testInput2 = [
  "two1nine",
  "eightwothree",
  "abcone2threexyz",
  "xtwone3four",
  "4nineeightseven2",
  "zoneight234",
  "7pqrstsixteen",
]

# Damn overlapping numbers
def subTextForNumbers(text)
  text.gsub('one', 'o1e')
      .gsub('two', 't2o')
      .gsub('three', 'thr3e')
      .gsub('four', 'fo4r')
      .gsub('five', 'f5ve')
      .gsub('six', 's6x')
      .gsub('seven', 'se7en')
      .gsub('eight', 'ei8ht')
      .gsub('nine', 'n9ne')
      .gsub('zero', 'ze0o')
end

# Part One
calibrationValues = calibration.map do |line|
  digit = line.scan(/\d/).join('').to_s
  value = (digit[0] + digit[digit.length-1]).to_i
end

puts "Part One: #{calibrationValues.sum} is the sum of all of the calibration values"

# Part Two
calibrationValuesWithStringNumbers = calibration.map do |line|
  digit = subTextForNumbers(line).scan(/\d/).join('').to_s
  value = (digit[0] + digit[digit.length-1]).to_i
end

puts "Part Two: #{calibrationValuesWithStringNumbers.sum} is the sum of all of the calibration values"
