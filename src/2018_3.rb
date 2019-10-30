require_relative "./reader"

# Solve 2018, problem 3
class TwentyEighteenThree
  include Reader

  def initialize
    data = Reader.read_data_from_file "2018_3"

    @data = data
            .reject { |l| l.start_with?("@") }
            .each_slice(3)
            .to_a
  end

  def solve
    {
      "part_one" => solve_part_one,
      "part_two" => solve_part_two
    }
  end

  def solve_part_one
    make_data_into_claims.select { |_k, v| v.length > 1 }.length
  end

  def solve_part_two
    flatten_unique_claim_ids = ->(v) { v.collect(&:last).flatten(2).uniq }

    claims_with_overlap, claims_without_overlap = make_data_into_claims
                                                  .to_a
                                                  .partition { |claim| claim.last.length > 1 }
                                                  .collect(&flatten_unique_claim_ids)

    claims_without_overlap.each do |id|
      unless claims_with_overlap.include?(id)
        return id
      end
    end
  end

  def make_data_into_claims
    claims_dictionary = @data.inject({}) do |acc, next_claim|
      next_claim_entries = make_claim_into_entries(next_claim)
      acc.merge(next_claim_entries) { |_k, o, n| o.concat(n) }
    end

    claims_dictionary
  end

  def make_claim_into_entries(claim)
    entry_dictionary = {}

    claim_id = claim.first
    starting_x, starting_y = claim
                             .drop(1)
                             .first
                             .delete_suffix(":")
                             .split(",")
                             .collect(&:to_i)
    width, height = claim.last.split("x").collect(&:to_i)

    (starting_x...(starting_x + width)).each do |x|
      (starting_y...(starting_y + height)).each do |y|
        entry_dictionary[[x, y]] = [claim_id]
      end
    end

    entry_dictionary
  end
end

puts TwentyEighteenThree.new.solve
