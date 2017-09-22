# frozen_string_literal: true

require_relative 'counter_system'

# The query method in this class finds the minimum of all corresponding boxes.
class MinimumCounterSystem < CounterSystem
  def query(num)
    @hash_functions.map { |hf| @counters[hf.id][hf.hash(num)] }.min
  end
end
