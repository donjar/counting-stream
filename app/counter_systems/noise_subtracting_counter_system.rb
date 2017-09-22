# frozen_string_literal: true

require_relative 'counter_system'
require_relative '../helpers/array_averages'
Array.include ArrayAverages

# The query method in this class tries to subtract noise as detailed in
# the problem set, algorithm 2.
class NoiseSubstractingCounterSystem < CounterSystem
  def query(num)
    @hash_functions.map do |hf|
      row = @counters[hf.id]
      hash_idx = hf.hash(num)
      if hash_idx.odd?
        (row[hash_idx] || 0) - (row[hash_idx - 1] || 0)
      else
        (row[hash_idx] || 0) - (row[hash_idx + 1] || 0)
      end
    end.median
  end
end
