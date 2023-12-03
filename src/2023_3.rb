require "pry"
require "memoist"
require "forwardable"

class TwentyTwentyThreeThree
  attr_reader :grid

  def initialize
    @grid = Grid.new(File.read("./data/2023_3.txt").split("\n").collect { _1.split("") })
  end

  def solve
    { solution_one:, solution_two: }
  end

  def solution_one
    grid.part_numbers_sum
  end

  def solution_two
    grid.gear_ratios.collect { _1 * _2 }.sum
  end
end

class Grid
  extend Memoist

  attr_reader :data

  def initialize(data)
    @data = data.collect.with_index do |row, row_index|
      row.collect.with_index do |value, column_index|
        Cell.new(value:, row_index:, column_index:, grid: self)
      end
    end
  end

  def part_numbers_sum
    part_numbers.select(&:neighbors_symbol?).collect(&:value).sum
  end

  def gear_ratios
    part_numbers
      .select(&:neighbors_gear?).collect.with_index do |part_number, index|
        part_number_sharing_gear = part_numbers[index.succ...].detect do |later_part_number|
          later_part_number != part_number && part_number.shares_neighboring_gear?(later_part_number) # rubocop:disable Metrics/LineLength
        end

        unless part_number_sharing_gear.nil?
          [
            part_number,
            part_number_sharing_gear
          ].sort_by(&:value)
        end
      end # rubocop:disable Style/MultilineBlockChain
      .compact
      .uniq
      .collect { _1.collect(&:value) }
  end

  memoize def part_numbers
    data.collect do |row|
      row
        .chunk_while { _1.number? } # rubocop:disable Style/SymbolProc
        .collect { _1.take_while(&:number?) }
        .reject(&:empty?)
        .collect { PartNumber.new(_1) }
    end.flatten
  end

  memoize def cell_at(row_index, column_index)
    data.dig(row_index, column_index)
  end
end

class PartNumber
  attr_reader :cells, :value

  def initialize(cells)
    @value = cells.collect(&:value).join("").to_i
    @cells = cells
  end

  def ==(other)
    value == other.value
  end

  def neighbors_symbol?
    cells.any? { _1.neighbors.any?(&:symbol?) }
  end

  def neighbors_gear?
    neighboring_gears.any?
  end

  def neighboring_gears
    cells.collect(&:neighboring_gears).reject(&:empty?).flatten
  end

  def shares_neighboring_gear?(other)
    neighboring_gears.any? { other.neighboring_gears.include?(_1) }
  end
end

class Cell
  extend Memoist
  extend Forwardable

  def_delegators :grid, :cell_at

  attr_reader :value, :row_index, :column_index, :grid

  def initialize(value:, row_index:, column_index:, grid:)
    @value = value
    @row_index = row_index
    @column_index = column_index
    @grid = grid
  end

  def ==(other)
    value == other.value && row_index == other.row_index && column_index == other.column_index
  end

  memoize def number
    numeric_string = value.tr("^0-9", "")

    return if numeric_string.empty?

    numeric_string.to_i
  end

  def number?
    !number.nil?
  end

  memoize def period
    value.tr("^.", "")
  end

  def period?
    !period.empty?
  end

  memoize def symbol
    return if number? || period?

    value
  end

  def symbol?
    !symbol.nil?
  end

  def gear?
    !value.tr("^*", "").empty?
  end

  def neighboring_gears
    neighbors.select(&:gear?)
  end

  def neighbors
    [west, east, north, south, northwest, northeast, southeast, southwest].compact
  end

  def west
    cell_at(row_index, column_index.pred)
  end

  def east
    cell_at(row_index, column_index.succ)
  end

  def north
    cell_at(row_index.pred, column_index)
  end

  def south
    cell_at(row_index.succ, column_index)
  end

  def northwest
    cell_at(row_index.pred, column_index.pred)
  end

  def northeast
    cell_at(row_index.pred, column_index.succ)
  end

  def southeast
    cell_at(row_index.succ, column_index.succ)
  end

  def southwest
    cell_at(row_index.succ, column_index.pred)
  end

  Inspector = Struct.new(:value, :row_index, :column_index)

  def inspect
    Inspector.new(value:, row_index:, column_index:)
  end
end

puts TwentyTwentyThreeThree.new.solve
