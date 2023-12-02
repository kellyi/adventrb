require "pry"
require "memoist"

class TwentyTwentyThreeTwo
  attr_reader :data

  def initialize
    @data = File
            .read("./data/2023_2.txt")
            .split("\n")
            .collect { _1.split(":") }
            .group_by(&:first)
            .transform_values { _1.flatten.drop(1) }
            .collect { Game.new(_1) }
  end

  def solve
    { solution_one:, solution_two: }
  end

  def solution_one
    data.select(&:valid?).collect(&:value).sum
  end

  def solution_two
    data.collect(&:power).sum
  end

  class Game
    extend Memoist

    MAXIMUM_RED_CUBES = 12
    MAXIMUM_GREEN_CUBES = 13
    MAXIMUM_BLUE_CUBES = 14

    attr_reader :game_number, :game_data

    def initialize(record)
      @game_number = record.first
      @game_data = record.last.first.strip.split("; ").collect do |round|
        round.split(", ").collect do
          _1.split(" ")
        end
      end
    end

    def power
      maximum_blue * maximum_green * maximum_red
    end

    def valid?
      game_data.all? do |round|
        round.all? do |turn|
          value, color = turn

          case color
          when "green"
            value.to_i <= MAXIMUM_GREEN_CUBES
          when "blue"
            value.to_i <= MAXIMUM_BLUE_CUBES
          when "red"
            value.to_i <= MAXIMUM_RED_CUBES
          else
            true
          end
        end
      end
    end

    def value
      game_number.tr("^0-9", "").to_i
    end

    private

    memoize def maximum_blue
      maximum_for("blue")
    end

    memoize def maximum_green
      maximum_for("green")
    end

    memoize def maximum_red
      maximum_for("red")
    end

    def maximum_for(color)
      result = 0

      game_data.each do |round|
        round.each do |turn|
          value, turn_color = turn
          next unless turn_color == color

          result = value.to_i if result < value.to_i
        end
      end

      result
    end
  end
end

puts TwentyTwentyThreeTwo.new.solve
