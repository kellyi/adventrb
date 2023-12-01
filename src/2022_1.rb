class TwentyTwentyTwoOne
  attr_reader :data

  def initialize
    @data = File.read("./data/2022_1.txt").split("\n").chunk_while { _1.length.positive? }
  end

  def solve
    { solution_one:, solution_two: }
  end

  def solution_one
    sums.first
  end

  def solution_two
    sums.take(3).sum
  end

  def sums
    data.collect { _1.collect(&:to_i) }.collect(&:sum).sort_by(&:-@)
  end
end

puts TwentyTwentyTwoOne.new.solve
