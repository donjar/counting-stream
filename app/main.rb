# frozen_string_literal: true

Dir['counter_systems/*.rb'].each { |f| require_relative f }

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

# rubocop:disable Metrics/AbcSize, Metrics/MethodLength
def generate_report(file:, a:, b:, stream:)
  stats = stream.each_with_object(Hash.new(0)) { |i, s| s[i] += 1 }.sort.to_h
  median, noise, minimum = feed_counters(a: a, b: b, stream: stream)

  CSV.open(file, 'wb') do |csv|
    csv << ['a', a, 'b', b, 'count', stream.length, 'unique', stats.keys.length]
    csv << ['keys'] + stats.keys
    csv << ['values'] + stats.values
    csv << ['median'] + median.get_values(stats.keys)
    csv << ['noise'] + noise.get_values(stats.keys)
    csv << ['minimum'] + minimum.get_values(stats.keys)
  end
end
# rubocop:enable Metrics/AbcSize, Metrics/MethodLength

def reports_with_fixed_space(folder:, size:, stream:)
  pb = ProgressBar.create(total: size)
  size.times.each do |a|
    pb.increment
    next if a.zero?
    b = size / a
    next if a != 1 && b == size / (a + 1) # suboptimal

    long_folder = "res/#{folder}"
    FileUtils.mkdir_p long_folder
    filename = "#{long_folder}/a#{a}_b#{b}.csv"
    generate_report(file: filename, a: a, b: b, stream: stream)
  end
end
