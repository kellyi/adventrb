require "pry"
require "memoist"

class TwentyTwentyFourOne
  extend Memoist

  attr_reader :data

  def initialize
    @data = File.read("./data/2024_1.txt").split("\n").collect { _1.split(" ").collect(&:to_i) }
  end

  def solve
    { solution_one:, solution_two: }
  end

  private

  def solution_one
    lefts
      .each_with_index
      .inject(0) { |accumulator, (current, i)| accumulator + (current - rights.at(i)).abs }
  end

  def solution_two
    lefts.inject(0) { |accumulator, current| accumulator + (current * rights.count(current)) }
  end

  memoize def lefts
    data.collect(&:first).sort
  end

  memoize def rights
    data.collect(&:last).sort
  end
end

puts TwentyTwentyFourOne.new.solve
