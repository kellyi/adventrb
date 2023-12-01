require "pry"

class TwentyTwentyThreeOne
  attr_reader :data

  def initialize
    @data = File.read("./data/2023_1.txt").split("\n")
  end

  def solve
    { solution_one:, solution_two: }
  end

  def solution_one
    data.collect { map_row_one(_1) }.collect(&:to_i).sum
  end

  def solution_two
    data.collect { map_row_two(_1) }.collect(&:to_i).sum
  end

  def map_row_one(row)
    entry = row.gsub(/[^\d]/, "").split("")
    entry.first + entry.last
  end

  def map_row_two(row)
    copied_row = row.dup
    result = []

    while copied_row.length.positive?
      potential_word = NUMBER_WORDS.detect { copied_row.start_with?(_1) }
      potential_digit = DIGITS.detect { copied_row.start_with?(_1) }

      if potential_digit
        result << potential_digit
      elsif potential_word
        result << NUMBER_WORDS.index(potential_word).to_s
      end

      copied_row = copied_row[1..]
    end

    result.first + result.last
  end

  NUMBER_WORDS = %w[zero one two three four five six seven eight nine].freeze
  DIGITS = %w[0 1 2 3 4 5 6 7 8 9].freeze
end

puts TwentyTwentyThreeOne.new.solve
