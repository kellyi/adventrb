# Solve 2019, problem 4
class TwentyNineteenFour
  def initialize
    @data = [271973, 785961]
  end

  def password_range
    map_into_digits = ->(s) { s.to_s.split("").collect(&:to_i) }
    (@data.first..@data.last).collect(&map_into_digits)
  end

  def solve
    {
      "part_one" => solve_part_one,
      "part_two" => solve_part_two
    }
  end

  def solve_part_one
    take_any_repeating_digits = lambda do |digits|
      digits.each_cons(2).any? { |x, y| x == y }
    end

    take_only_non_decreasing = lambda do |digits|
      digits.each_cons(2).all? { |x, y| x <= y }
    end

    password_range
      .select(&take_any_repeating_digits)
      .select(&take_only_non_decreasing)
      .count
  end

  def solve_part_two
    take_only_non_decreasing = lambda do |digits|
      digits.each_cons(2).all? { |x, y| x <= y }
    end

    identity = ->(e) { e }

    chunk_by_repeating_digits = lambda do |digits|
      digits.chunk(&identity).to_a
    end

    take_only_two_repeated_digits = lambda do |encoded_digits|
      encoded_digits.any? { |v| v.last.length == 2 }
    end

    password_range
      .select(&take_only_non_decreasing)
      .collect(&chunk_by_repeating_digits)
      .select(&take_only_two_repeated_digits)
      .count
  end
end

puts TwentyNineteenFour.new.solve
