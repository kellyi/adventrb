require "pry"
require "memoist"

class TwentyTwentyFourTwo
  attr_reader :data

  def initialize
    @data = File.read("./data/2024_2.txt").split("\n").collect { _1.split(" ").collect(&:to_i) }
  end

  def solve = { solution_one:, solution_two: }

  private

  def solution_one = solution(:all_safe?)

  def solution_two = solution(:safe_with_removal?)

  def solution(method_name)
    data.inject(0) { |acc, current| method(method_name).call(current) ? acc.succ : acc }
  end

  def all_safe?(row)
    row.each_cons(2).all? { |r, l| row.at(0) < row.at(1) ? safe_pair?(r, l) : safe_pair?(l, r) }
  end

  def safe_with_removal?(row)
    all_safe?(row) || row.each_with_index.any? { |_, i| all_safe?(row[...i].concat(row[i.succ..])) }
  end

  def safe_pair?(right, left)
    left - right >= 1 && left - right <= 3
  end
end

puts TwentyTwentyFourTwo.new.solve
