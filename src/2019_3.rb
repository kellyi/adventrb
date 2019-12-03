require_relative "./reader"

# Solve 2019, problem 4
class TwentyNineteenThree
  include Reader

  CENTRAL_POINT = [0, 0].freeze
  RIGHT = "R".freeze
  LEFT = "L".freeze
  UP = "U".freeze
  DOWN = "D".freeze

  def initialize
    @data = Reader.read_data_from_file "2019_3", "\n"
  end

  def wires
    @data.collect { |wire| wire.split "," }
  end

  def solve
    {
      "part_one" => solve_part_one,
      "part_two" => solve_part_two
    }
  end

  def solve_part_one
    wire_one, wire_two = wires

    calculate_distance = ->(p) { calculate_manhattan_distance(p) }

    wire_one_points = convert_wire_directions_to_points_with_distances(wire_one)
    wire_two_points = convert_wire_directions_to_points_with_distances(wire_two)

    wire_one_points
      .select { |k, _v| wire_two_points.include?(k) }
      .keys
      .collect(&calculate_distance)
      .min
      .to_i
  end

  def solve_part_two
    wire_one, wire_two = wires

    wire_one_points = convert_wire_directions_to_points_with_distances(wire_one)
    wire_two_points = convert_wire_directions_to_points_with_distances(wire_two)

    wire_one_intersections = wire_one_points.select { |k, _v| wire_two_points.include?(k) }
    wire_two_intersections = wire_two_points.select { |k, _v| wire_one_points.include?(k) }

    distances = wire_one_intersections.merge!(wire_two_intersections) { |_k, v1, v2| v1 + v2 }
    distances.values.min
  end

  def convert_wire_directions_to_points_with_distances(wire, wire_points = {})
    if wire.empty?
      return wire_points
    end

    next_movement, *rest = wire
    starting_point = wire_points.keys.last || CENTRAL_POINT
    starting_distance = wire_points.values.last || 0
    direction, *steps = next_movement.chars
    steps = steps.join.to_i

    new_points = create_new_points(direction, steps, starting_point, starting_distance)
    wire_points.merge!(new_points) { |_key, v1, _v2| v1 }
    convert_wire_directions_to_points_with_distances(rest, wire_points)
  end

  def create_new_points(direction, steps, starting_point, starting_distance)
    new_wire_points = {}
    x, y = starting_point

    update_x = ->(new_x, index) { new_wire_points[[new_x, y]] = (starting_distance + index + 1) }
    update_y = ->(new_y, index) { new_wire_points[[x, new_y]] = (starting_distance + index + 1) }

    case direction
    when RIGHT
      (x + 1).upto(x + steps).each_with_index(&update_x)
    when LEFT
      (x - 1).downto(x - steps).each_with_index(&update_x)
    when UP
      (y + 1).upto(y + steps).each_with_index(&update_y)
    when DOWN
      (y - 1).downto(y - steps).each_with_index(&update_y)
    end

    new_wire_points
  end

  def calculate_manhattan_distance(point)
    (point.first - CENTRAL_POINT.first).abs + (point.last - CENTRAL_POINT.last).abs
  end
end

puts TwentyNineteenThree.new.solve
