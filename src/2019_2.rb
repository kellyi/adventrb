require_relative "./reader"

module Computer
  ADDITION = 1
  MULTIPLICATION = 2
  END_CONDITION = 99

  def self.run_program(program, pointer = 0)
    instruction = program[pointer]

    if instruction == END_CONDITION
      return program.first
    end

    left_input_address = program[pointer + 1]
    right_input_address = program[pointer + 2]
    left_input = program[left_input_address]
    right_input = program[right_input_address]

    output_value = instruction == ADDITION ? left_input + right_input : left_input * right_input
    output_address = program[pointer + 3]
    program[output_address] = output_value

    run_program(program, pointer + 4)
  end
end

# Solve 2019, problem 2
class TwentyNineteenTwo
  include Reader
  include Computer

  TARGET_VALUE = 19690720

  def initialize
    @data = Reader.read_data_from_file("2019_2", ",")
  end

  def instructions
    @data.collect(&:to_i)
  end

  def solve
    {
      "part_one" => solve_part_one,
      "part_two" => solve_part_two
    }
  end

  def solve_part_one
    program = instructions.dup
    program[1..2] = [12, 2]
    Computer.run_program(program)
  end

  def solve_part_two
    (0..99).each do |noun|
      (0..99).each do |verb|
        program = instructions.dup
        program[1..2] = [noun, verb]

        if Computer.run_program(program) == TARGET_VALUE
          return (100 * noun) + verb
        end
      end
    end
  end
end

puts TwentyNineteenTwo.new.solve
