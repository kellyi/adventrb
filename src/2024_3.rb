require "pry"
require "memoist"

class TwentyTwentyFourThree
  attr_reader :data

  def initialize
    @data = File.read("./data/2024_3.txt")
  end

  def solve = { solution_one:, solution_two: }

  private

  def solution_one
    data.scan(/mul\(\d+,\d+\)/).then(&method(:sum_multiplied_entries))
  end

  def solution_two
    data
      .scan(/mul\(\d+,\d+\)|don't\(\)|do\(\)/)
      .inject([true, []], &method(:collect_if_enabled))
      .last
      .then(&method(:sum_multiplied_entries))
  end

  def sum_multiplied_entries(list)
    list.inject(0) { _1 + _2.split("(").last.split(",").collect(&:to_i).inject(:*) }
  end

  def collect_if_enabled((enabled, list), current_element)
    return [current_element == "do()", list] if current_element.start_with?("do")

    [enabled, list.concat(enabled ? [current_element] : [])]
  end
end

puts TwentyTwentyFourThree.new.solve
