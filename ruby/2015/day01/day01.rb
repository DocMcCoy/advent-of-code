$instructionSet = File.read('day01.txt')

puts 'Here is the instruction set:'
puts $instructionSet
puts "Part 1: The instructions take Santa to floor #{$instructionSet.count('(') - $instructionSet.count(')')}"

def getInstructionNumberByFloor(floorNumber, startingFloor = 0)
  floor = startingFloor
  instructionNumber = 0
  $instructionSet.split('').each do |instruction|
    instructionNumber += 1
    floor += (instruction == '(' ? 1 : -1)
    if floor == floorNumber
      return instructionNumber
    end
  end
  return -1
end

puts "Part 2: Santa first enters the basement at instruction #{getInstructionNumberByFloor(-1)}"
