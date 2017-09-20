module ArrayMedian
  # Implement the median method in Array
  class Array
    def median
      sorted = sort
      len = length
      if len.odd?
        sorted[len / 2]
      else
        (sorted[len / 2] + sorted[len / 2 + 1]) / 2.0
      end
    end
  end
end
