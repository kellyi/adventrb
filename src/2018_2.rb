require_relative "./reader"

# Solve 2018, problem 2
class TwentyEighteenTwo
  include Reader

  def initialize
    @data = Reader.read_data_from_file "2018_2"
  end

  def solve
    {
      "part_one" => solve_part_one,
      "part_two" => solve_part_two
    }
  end

  def solve_part_one
    @data.count { |s| two_of_a_letter?(s) } * @data.count { |s| three_of_a_letter?(s) }
  end

  def two_of_a_letter?(str)
    n_occurences_of_a_letter?(str, 2)
  end

  def three_of_a_letter?(str)
    n_occurences_of_a_letter?(str, 3)
  end

  def n_occurences_of_a_letter?(str, occurences_count)
    str.split("").any? { |c| str.count(c) == occurences_count }
  end

  def solve_part_two
    result = nil

    @data.each do |str_one|
      @data.each do |str_two|
        if differ_by_only_one_char?(str_one, str_two)
          result = [str_one, str_two].collect { |s| s.split("") }
          break
        end
      end
    end

    (result.first & result.last).join("")
  end

  def differ_by_only_one_char?(str_one, str_two)
    intersection = str_one.split("") & str_two.split("")
    intersection.count == str_one.length - 1
  end
end

puts TwentyEighteenTwo.new.solve
