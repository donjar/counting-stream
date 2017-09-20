# frozen_string_literal: true

require_relative '../hash_function'

# This is the base CounterSystem clsas, providing methods to insert numbers
# (from a stream) and query them. The querying is to be implemented by its
# subclasses.
class CounterSystem
  def initialize(a:, b:)
    @counters = Array.new(a) { Array.new(b).fill(0) }
    @hash_functions = Array.new(a) do |idx|
      HashFunction.new(range_size: b, id: idx)
    end
  end

  def insert(num)
    [].tap do |hash_results|
      @hash_functions.each_with_index do |hf, i|
        hash_result = hf.hash(num)
        @counters[i][hash_result] += 1
        hash_results << hash_result
      end
    end
  end

  def query(_num)
    raise 'You need to implement query in subclasses of CounterSystem'
  end

  def self.measure(a:, b:, stream:) # rubocop:disable Metrics/AbcSize
    counter = new(a: a, b: b)
    stream.each { |item| counter.insert(item) }

    stats = stream.each_with_object(Hash.new(0)) { |item, s| s[item] += 1 }
    stats.keys.sort.each do |item|
      puts <<~TEXT.tr("\n", ' ')
        Item #{item} is in the stream #{stats[item]} times, counted
        #{counter.query(item)} times. Error rate:
        #{(counter.query(item) - stats[item]).abs / item}
      TEXT
    end
  end
end
