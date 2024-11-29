require "pry"

class TwentySeventeenOne
  attr_reader :data

  def initialize
    @data = File.read("./data/2017_1.txt").strip.split("").collect(&:to_i)
  end

  def solve
    { solution_one:, solution_two: }
  end

  private

  def solution_one
    data
      .concat(data.take(1))
      .slice_when { _1 != _2 }
      .reject { _1.length < 2 }
      .collect { _1.drop(1) }
      .collect(&:sum)
      .sum
  end

  def solution_two
    initial_list_length = data.length
    indices_to_skip = initial_list_length / 2

    data
      .concat(data)
      .each_with_index
      .inject(0) do |accumulator, (current_element, current_index)|
      return accumulator if current_index >= initial_list_length

      element_to_check = data[current_index + indices_to_skip]

      if element_to_check == current_element
        accumulator + current_element
      else
        accumulator
      end
    end
  end
end

puts TwentySeventeenOne.new.solve
