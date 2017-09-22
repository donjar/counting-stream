# frozen_string_literal: true

require_relative 'counter_system'
require_relative '../helpers/array_averages'
Array.include ArrayMedian

# The query method in this class finds the median of all corresponding boxes.
class MedianCounterSystem < CounterSystem
  def query(num)
    @hash_functions.map { |hf| @counters[hf.id][hf.hash(num)] }.median
  end
end
