# frozen_string_literal: true

# This is the base CounterSystem clsas, providing methods to insert numbers
# (from a stream) and query them. The querying is to be implemented by its
# subclasses.
class CounterSystem
  def initialize(a:, b:, hash_function:)
    @counters = Array.new(a) { Array.new(b).fill(0) }
    @hash_functions = Array.new(a) do |idx|
      hash_function.new(range_size: b, id: idx)
    end
  end

  def insert(num)
    [].tap do |hash_results|
      @hash_functions.each_with_index do |hf, i|
        hash_result = hf.hash(num)
        @counters[i][hash_result] += 1
        hash_results << hash_result
      end
    end
  end

  def query(_num)
    raise 'You need to implement query in subclasses of CounterSystem'
  end

  def get_values(queries)
    queries.map { |i| query(i) }
  end
end
