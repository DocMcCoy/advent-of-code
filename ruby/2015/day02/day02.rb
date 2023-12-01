dimensionData = File.read('day02.txt').chomp.split("\n")

# Setup the data
areas = []
dimensions = []
dimensionData.each do |lwh|
  lwh_array = lwh.split('x').map(&:to_i)

  areas << [
    lwh_array[0] * lwh_array[1],
    lwh_array[1] * lwh_array[2],
    lwh_array[2] * lwh_array[0]
  ]

  dimensions << lwh_array
end

# Part 1
box_areas_with_slack = []
areas.each do |area|
  slack = area.min
  box_areas_with_slack << area.map { |a| a * 2 }.inject(:+) + slack
end

puts "Part 1: The total area is #{box_areas_with_slack.sum} square feet."

# Part 2
ribbon_lengths = []
dimensions.each do |dimension|
  ribbon_lengths << dimension.sort[0..1].map { |d| d * 2 }.inject(:+) + dimension.inject(:*)
end

puts "Part 2: The total ribbon length is #{ribbon_lengths.sum} feet."
