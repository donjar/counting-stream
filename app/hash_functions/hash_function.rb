# frozen_string_literal: true

# Interface for the hash functions.
class HashFunction
  attr_accessor :id

  def initialize(range_size:, id:)
    raise 'Implement initialize'
  end

  def hash(num)
    raise 'Implement hash'
  end
end
