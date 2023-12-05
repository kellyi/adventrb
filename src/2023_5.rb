require "pry"
require "memoist"
require "forwardable"

class TwentyTwentyThreeFive
  extend Memoist

  attr_reader :data

  def initialize
    @data = File
            .read("./data/2023_5.txt")
            .split("\n")
            .chunk_while { _1 != "" }
            .collect { _1[0..-2] }
  end

  def solve
    { solution_one:, solution_two: }
  end

  def solution_one
    seeds.collect(&:location).min
  end

  def solution_two; end

  memoize def seeds
    data.first.first.split("seeds: ").last.split(" ").collect do
      Seed.new(_1, almanac_maps_collection)
    end
  end

  memoize def almanac_maps_collection
    AlmanacMapsCollection.new(data)
  end
end

class Seed
  extend Memoist
  extend Forwardable

  def_delegators :almanac_maps_collection, :seed_to_soil_map, :soil_to_fertilizer_map,
                 :fertilizer_to_water_map, :water_to_light_map, :light_to_temperature_map,
                 :temperature_to_humidity_map, :humidity_to_location_map

  attr_reader :number, :almanac_maps_collection

  def initialize(data, almanac_maps_collection)
    @number = data.to_i
    @almanac_maps_collection = almanac_maps_collection
  end

  def inspect
    Inspector.new(number:, soil:, fertilizer:, water:, light:, temperature:, humidity:, location:)
  end

  Inspector = Struct.new(:number, :soil, :fertilizer, :water, :light, :temperature, :humidity,
                         :location)

  def soil
    seed_to_soil_map.get(number)
  end

  def fertilizer
    soil_to_fertilizer_map.get(soil)
  end

  def water
    fertilizer_to_water_map.get(fertilizer)
  end

  def light
    water_to_light_map.get(water)
  end

  def temperature
    light_to_temperature_map.get(light)
  end

  def humidity
    temperature_to_humidity_map.get(temperature)
  end

  def location
    humidity_to_location_map.get(humidity)
  end
end

class AlmanacMapsCollection
  extend Memoist

  attr_reader :almanac_maps

  def initialize(data)
    @almanac_maps = data[1..].collect { AlmanacMap.new(_1) }
  end

  memoize def seed_to_soil_map
    almanac_maps.detect { _1.type == ::AlmanacMap::SEED_TO_SOIL_MAP }
  end

  memoize def soil_to_fertilizer_map
    almanac_maps.detect { _1.type == ::AlmanacMap::SOIL_TO_FERTILIZER_MAP }
  end

  memoize def fertilizer_to_water_map
    almanac_maps.detect { _1.type == ::AlmanacMap::FERTILIZER_TO_WATER_MAP }
  end

  memoize def water_to_light_map
    almanac_maps.detect { _1.type == ::AlmanacMap::WATER_TO_LIGHT_MAP }
  end

  memoize def light_to_temperature_map
    almanac_maps.detect { _1.type == ::AlmanacMap::LIGHT_TO_TEMPERATURE_MAP }
  end

  memoize def temperature_to_humidity_map
    almanac_maps.detect { _1.type == ::AlmanacMap::TEMPERATURE_TO_HUMIDITY_MAP }
  end

  memoize def humidity_to_location_map
    almanac_maps.detect { _1.type == ::AlmanacMap::HUMIDITY_TO_LOCATION_MAP }
  end
end

class AlmanacMap
  extend Memoist

  SEED = "seed".freeze
  SOIL = "soil".freeze
  FERTILIZER = "fertilizer".freeze
  WATER = "water".freeze
  LIGHT = "light".freeze
  TEMPERATURE = "temperature".freeze
  HUMIDITY = "humidity".freeze
  LOCATION = "location".freeze

  SEED_TO_SOIL_MAP = "seed-to-soil map:".freeze
  SOIL_TO_FERTILIZER_MAP = "soil-to-fertilizer map:".freeze
  FERTILIZER_TO_WATER_MAP = "fertilizer-to-water map:".freeze
  WATER_TO_LIGHT_MAP = "water-to-light map:".freeze
  LIGHT_TO_TEMPERATURE_MAP = "light-to-temperature map:".freeze
  TEMPERATURE_TO_HUMIDITY_MAP = "temperature-to-humidity map:".freeze
  HUMIDITY_TO_LOCATION_MAP = "humidity-to-location map:".freeze

  attr_reader :type, :entries

  def initialize(data)
    @type = data.first
    @entries = data[1..].collect { MapEntry.new(_1) }
  end

  memoize def get(key)
    to_h.fetch(key, key)
  end

  memoize def to_h
    entries.inject({}) { |accumulator, entry| accumulator.merge(entry.to_h) }
  end

  memoize def source_category
    case type
    when SEED_TO_SOIL_MAP
      SEED
    when SOIL_TO_FERTILIZER_MAP
      SOIL
    when FERTILIZER_TO_WATER_MAP
      FERTILIZER
    when WATER_TO_LIGHT_MAP
      WATER
    when LIGHT_TO_TEMPERATURE_MAP
      LIGHT
    when TEMPERATURE_TO_HUMIDITY_MAP
      TEMPERATURE
    when HUMIDITY_TO_LOCATION_MAP
      HUMIDITY
    end
  end

  memoize def destination_category
    case type
    when SEED_TO_SOIL_MAP
      SOIL
    when SOIL_TO_FERTILIZER_MAP
      FERTILIZER
    when FERTILIZER_TO_WATER_MAP
      WATER
    when WATER_TO_LIGHT_MAP
      LIGHT
    when LIGHT_TO_TEMPERATURE_MAP
      TEMPERATURE
    when TEMPERATURE_TO_HUMIDITY_MAP
      HUMIDITY
    when HUMIDITY_TO_LOCATION_MAP
      LOCATION
    end
  end

  class MapEntry
    extend Memoist

    attr_reader :destination_range_start, :source_range_start, :range_length

    def initialize(data)
      @destination_range_start, @source_range_start, @range_length = data.split(" ").collect(&:to_i)
    end

    memoize def to_h
      Hash[source_range.zip(destination_range)]
    end

    def destination_range
      destination_range_start.upto(destination_range_start + range_length).to_a
    end

    def source_range
      source_range_start.upto(source_range_start + range_length).to_a
    end
  end
end

puts TwentyTwentyThreeFive.new.solve
