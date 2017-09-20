# frozen_string_literal: true

# Adds the median method to arrays
module ArrayMedian
  def median
    sorted = sort
    len = length
    if len.odd?
      sorted[len / 2]
    else
      (sorted[len / 2 - 1] + sorted[len / 2]) / 2.0
    end
  end
end
