# frozen_string_literal: true

# Adds the median method to arrays
module ArrayAverages
  def median
    sorted = sort
    len = length
    if len.odd?
      sorted[len / 2]
    else
      (sorted[len / 2 - 1] + sorted[len / 2]) / 2.0
    end
  end

  def mean
    sum / length
  end
end
