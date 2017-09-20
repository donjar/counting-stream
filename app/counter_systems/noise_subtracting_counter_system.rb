# frozen_string_literal: true

require_relative 'counter_system'
require_relative '../helpers/array_median'
Array.include ArrayMedian

# The query method in this class tries to subtract noise as detailed in
# the problem set, algorithm 2.
class NoiseSubstractingCounterSystem < CounterSystem
  def query(num)
    @hash_functions.map do |hf|
      row = @counters[hf.id]
      hash_idx = hf.hash(num)
      if hash_idx.odd?
        row[hash_idx] - row[hash_idx - 1]
      else
        row[hash_idx] - row[hash_idx + 1]
      end
    end.median
  end
end
