# frozen_string_literal: true

require_relative 'counter_systems/median_counter_system.rb'
require_relative 'counter_systems/minimum_counter_system.rb'
require_relative 'counter_systems/noise_subtracting_counter_system.rb'

require 'csv'
require 'fileutils'
require 'ruby-progressbar'

def feed_counters(a:, b:, stream:)
  median = MedianCounterSystem.new(a: a, b: b)
  noise = NoiseSubstractingCounterSystem.new(a: a, b: b)
  minimum = MinimumCounterSystem.new(a: a, b: b)

  [median, noise, minimum].each do |c|
    stream.each { |i| c.insert(i) }
  end
end

def generate_reports(name:, size:, stream:)
  pb = ProgressBar.create(total: 9 * (2 * Math.sqrt(size) - 2))

  stats = stream.each_with_object(Hash.new(0)) { |i, s| s[i] += 1 }.sort.to_h

  folder = "res/#{name}"
  FileUtils.mkdir_p folder

  CSV.open("res/#{name}.csv", 'wb') do |summary_csv|
    summary_csv << ['total', stream.length]
    summary_csv << %w[a b median noise minimum]
    1.upto(size) do |a|
      b = size / a
      next if a != 1 && b == size / (a + 1) # suboptimal
      next if b == 1 # error

      median, noise, minimum = feed_counters(a: a, b: b, stream: stream)
      pb += 3

      keys = stats.keys
      median_err = keys.map { |k| (median.query(k) - stats[k]).abs }.sum / size.to_f
      pb.increment
      noise_err = keys.map { |k| (noise.query(k) - stats[k]).abs }.sum / size.to_f
      pb.increment
      minimum_err = keys.map { |k| (minimum.query(k) - stats[k]).abs }.sum / size.to_f
      pb.increment

      summary_csv << [a, b, median_err, noise_err, minimum_err]

      file = "#{folder}/a#{a}_b#{b}.csv"
      CSV.open(file, 'wb') do |csv|
        csv << ['a', a, 'b', b, 'count', stream.length, 'unique',
                stats.keys.length]
        csv << ['keys'] + keys
        csv << ['values'] + stats.values
        csv << ['median'] + median.get_values(stats.keys)
        pb.increment
        csv << ['noise'] + noise.get_values(stats.keys)
        pb.increment
        csv << ['minimum'] + minimum.get_values(stats.keys)
        pb.increment
      end
    end
  end
end

def uniform_stream(ints:, total:)
  Array.new(total) { Random.rand(ints) }
end

def exponential_stream(ints:, total:)
  Array.new(total) { ints - Math.log(Random.rand(2**50), 2).ceil }
end

def binomial_stream(ints:, total:)
  Array.new(total) { Array.new(ints) { Random.rand(2) }.sum }
end

def stream_to_ints(stream)
  hash = {}
  count = 0
  stream.map do |item|
    if hash[item].nil?
      hash[item] = count
      count += 1
    end
    hash[item]
  end
end

def text_to_words(text)
  text.gsub(/\s+/, ' ').gsub(/[^a-zA-Z ]/, ' ').downcase.split(' ')
end
