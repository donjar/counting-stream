require_relative 'counter_system'
require_relative 'helpers/array_median'

# The query method in this class tries to subtract noise as detailed in
# the problem set, algorithm 2.
class NoiseSubstractingCounterSystem < CounterSystem
  def query(_num)
    @hash_functions.map.with_index do |hf, i|
      row = @counters[i]
      hash_idx = hf.hash(i)
      if hash_idx.odd?
        row[hash_idx] - row[hash_idx - 1]
      else
        row[hash_idx] - row[hash_idx + 1]
      end
    end.median
  end
end
