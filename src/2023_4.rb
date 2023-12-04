require "pry"
require "memoist"

class TwentyTwentyThreeFour
  attr_reader :data

  def initialize
    @data = File.read("./data/2023_4.txt").split("\n").collect { Card.new(_1) }
  end

  def solve
    { solution_one:, solution_two: }
  end

  def solution_one
    data.sum(&:point_value)
  end

  def solution_two
    duplicate_data = data.dup
    i = 0

    while i < duplicate_data.count
      duplicate_data[i].next_numbers.each do |next_number|
        duplicate_data.append(duplicate_data.find { _1.number == next_number }.dup)
      end

      i += 1
    end

    duplicate_data.count
  end
end

class Card
  extend Memoist

  attr_reader :number, :winning_numbers, :my_numbers

  def initialize(data)
    @number = data.split(":").first.tr("^0-9", "").to_i
    @winning_numbers, @my_numbers = data
                                    .split(":")
                                    .last
                                    .split(" | ")
                                    .collect { _1.strip.split(" ").collect(&:to_i) }
  end

  def point_value
    match_count.zero? ? 0 : 2**match_count.pred
  end

  memoize def match_count
    winning_numbers.intersection(my_numbers).count
  end

  memoize def next_numbers
    match_count.zero? ? [] : number.succ.upto(number + match_count)
  end
end

puts TwentyTwentyThreeFour.new.solve
