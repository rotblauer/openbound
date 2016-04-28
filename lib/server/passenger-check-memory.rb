#!/usr/bin/env ruby

# 512mb
LIMIT = 128 * 4

puts "Scanning memory stats..."
$lines = []
IO.popen("passenger-memory-stats") do |io|
    $lines = io.readlines
end

puts "Checking memory usage..."
$lines.each do |line|
    if line.match(/^(\d+)\s+([\d.]+)\s+MB/)
        pid = $1
        memory_usage = $2.to_f

        puts "Checking #{line}"

        # Avoid 'Passenger core', favoring on RubyApp threads.
        if memory_usage > LIMIT && line.match(/.+(RubyApp:)/)
            puts "Killing process: #{pid}, memory usage #{memory_usage} > #{LIMIT}..."
            Process.kill("KILL", pid.to_i)
        end
    end
end