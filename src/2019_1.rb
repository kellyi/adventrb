require_relative "./reader"

# Solve 2019, problem 1
class TwentyNineteenOne
  include Reader

  def initialize
    @data = Reader.read_data_from_file "2019_1"
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
    reduce_mass_fuel_values = ->(acc, m) { acc + calculate_fuel_from_mass(m) }
    numbers.inject(0, &reduce_mass_fuel_values)
  end

  def solve_part_two
    reduce_mass_fuel_values = lambda do |acc, mass|
      required_fuel = calculate_fuel_from_mass(mass)

      extra_fuel = required_fuel.dup

      until extra_fuel.zero?
        extra_fuel = calculate_fuel_from_mass(extra_fuel)
        required_fuel += extra_fuel
      end

      acc + required_fuel
    end

    numbers.inject(0, &reduce_mass_fuel_values)
  end

  def calculate_fuel_from_mass(mass)
    ((mass / 3) - 2).clamp(0, Float::INFINITY)
  end
end

puts TwentyNineteenOne.new.solve
