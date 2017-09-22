# frozen_string_literal: true

require_relative './hash_function.rb'

# Every time this hash function faces a new element, it will generate a random
# integer for it.
class PerfectHashFunction < HashFunction
  def initialize(range_size:, id:)
    @id = id
    @range = range_size
    @dict = {}
  end

  def hash(num)
    @dict[num] ||= Random.rand(@range)
  end
end
