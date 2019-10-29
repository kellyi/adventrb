require_relative "./reader"

# Solve 2018, problem 1
class TwentyEighteenOne
  include Reader

  def initialize
    @data = Reader.read_data_from_file "2018_1"
  end

  def numbers
    @data.collect(&:to_i)
  end

  def solve
    {
      "part_one" => solve_part_one,
      "part_two" => solve_part_two
    }
  end

  def solve_part_one
    numbers.inject(:+)
  end

  def solve_part_two
    encountered_frequencies = [0]

    numbers.cycle do |number|
      new_frequency = encountered_frequencies.last + number

      if encountered_frequencies.include?(new_frequency)
        encountered_frequencies.push(new_frequency)
        break
      end

      encountered_frequencies.push(new_frequency)
    end

    encountered_frequencies.last
  end
end

puts TwentyEighteenOne.new.solve
