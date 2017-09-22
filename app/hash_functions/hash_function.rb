# frozen_string_literal: true

# Interface for the hash functions.
class HashFunction
  attr_accessor :id

  def initialize(range_size:, id:) # rubocop:disable Lint/UnusedMethodArgument
    raise 'Implement initialize'
  end

  def hash(_num)
    raise 'Implement hash'
  end
end
