def day03_test_input
  [
    "467..114..",
    "...*......",
    "..35..633.",
    "......#...",
    "617*......",
    ".....+.58.",
    "..592.....",
    "......755.",
    "...$.*....",
    ".664.598..",
  ]
end

def day03_input
  File.read('day03.txt').chomp.split("\n")
end

def find_numbers_with_index(array)
  numbers_array = []
  array_to_get_index = []
  array.each_with_index do |line, index|
    line_index_start = index - 1 < 0 ? 0 : index - 1
    line_index_end   = index + 1 > array.length - 1 ?
                        array.length - 1 :
                        index + 1
    numbers = line.scan(/\d+/)
    array_to_get_index << line
    numbers.each do |number|
      # get the index of the number and then replace it with N * number.length in order to get the proper index for
      # the following numbers in case they would be similar to the previous
      number_index              = array_to_get_index[index].index(number)
      array_to_get_index[index] = array_to_get_index[index].sub(number, "N" * number.length)

      hash = {}

      hash[:number]        = number.to_i
      hash[:number_as_str] = number
      hash[:line_index]    = index
      hash[:number_index]  = number_index
      hash[:number_length] = number.length
      hash[:line_length]   = line.length

      indexes = []
      for i in number_index..number_index + number.length - 1
        indexes << i
      end
      hash[:indexes] = indexes

      num_index_start = hash[:number_index] - 1 < 0 ? 0 : hash[:number_index] - 1
      num_index_end   = hash[:number_index] + hash[:number_length] > line.length - 1 ?
                          line.length - 1 :
                          hash[:number_index] + hash[:number_length]

      array_to_check = array[line_index_start..line_index_end].map { |line| line[num_index_start..num_index_end] }

      hash[:is_part] = scan_for_non_numbers(array_to_check)

      numbers_array << hash
    end
  end

  numbers_array
end

def scan_for_non_numbers(array)
  is_part = false
  array.each do |line|
    line.each_char do |char|
      unless char.match?(/[0-9.]/)
        is_part = true
      end
    end
  end
  is_part
end

def find_asterisks input
  asterisks_array = []
  array_to_get_index = []
  input.each_with_index do |line, index|
    array_to_get_index << line
    asterisks = line.scan(/\*/)
    asterisks.each do |asterisk|
      asterisk_index            = array_to_get_index[index].index(asterisk)
      array_to_get_index[index] = array_to_get_index[index].sub(asterisk, "N")

      hash = {}

      hash[:line_index]      = index
      hash[:asterisk_index]  = asterisk_index

      asterisks_array << hash
    end
  end
  asterisks_array
end

def find_gears input
  asterisks = find_asterisks input
  numbers   = find_numbers_with_index input
  array_of_gears = []
  asterisks.each do |asterisk|
    array_of_gears << check_around_asterisk(asterisk, input, numbers) if check_around_asterisk(asterisk, input, numbers) != nil
  end
  p array_of_gears
  puts "The sum of all the gears is #{array_of_gears.sum}"
  array_of_gears
end

def check_around_asterisk asterisk, input, numbers
  line_index     = asterisk[:line_index]
  asterisk_index = asterisk[:asterisk_index]

  line        = input[line_index]
  line_length = line.length
  line_index_start = line_index - 1 < 0 ? 0 : line_index - 1
  line_index_end   = line_index + 1 > input.length - 1 ?
                        input.length - 1 :
                        line_index + 1
  num_index_start = asterisk_index - 1 < 0 ? 0 : asterisk_index - 1
  num_index_end   = asterisk_index + 1 > line.length - 1 ?
                        line.length - 1 :
                        asterisk_index + 1
  array_to_check = input[line_index_start..line_index_end].map { |line| line[num_index_start..num_index_end] }
  # puts array_to_check

  asterisk_lines_to_check = numbers.select { |number| number[:line_index] == line_index || number[:line_index] == line_index - 1 || number[:line_index] == line_index + 1  }

  asterisk_numbers = asterisk_lines_to_check.select { |asterisk_line_to_check| asterisk_line_to_check[:indexes].include?(asterisk_index) || asterisk_line_to_check[:indexes].include?(asterisk_index - 1) || asterisk_line_to_check[:indexes].include?(asterisk_index + 1)}

  if asterisk_numbers.length > 1
    gear_calc = asterisk_numbers[0][:number] * asterisk_numbers[1][:number]
  end

  gear_calc
end

def sum_parts input
  parts = find_numbers_with_index(input)
  parts.select { |part| part[:is_part] == true }.map { |part| part[:number] }.sum
end

puts "The sume of all the part numbers is #{sum_parts(day03_input)}"

find_gears(day03_input)
