require_relative 'counter_system'
require_relative 'helpers/array_median'

# The query method in this class finds the median of all corresponding boxes.
class MedianCounterSystem < CounterSystem
  def query(_num)
    @hash_functions.map.with_index { |hf, i| @counters[i][hf.hash(i)] }.median
  end
end
