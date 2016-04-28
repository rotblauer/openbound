#!/usr/bin/env ruby

# %CPU
LIMIT = 10

# puts "Scanning memory stats..."
puts "On the hunt for cpu hungry passengers."
$lines = []
IO.popen("passenger-status") do |io|
    $lines = io.readlines
end

# $xpid = '0'
# $xcpu = '0'
# $not_killed = {}
# $killed = {}
$pids = []

# puts "Checking memory usage..."
$lines.each do |line, i|
    if line.match(/PID\:\s(\d+)/)
        puts "Checking #{line}"
        pid = $1
        $pids.push(pid)
    end

    if line.match(/CPU\:\s(\d+)/)
        puts "Checking #{line}"
        cpu_usage = $1.to_f
        
        puts "CPU usage: #{cpu_usage}%"

        if cpu_usage > LIMIT
            last_pid = $pids.pop
            puts "Killing process #{last_pid}, CPU usage #{cpu_usage}% > #{LIMIT}%..."
            Process.kill("KILL", last_pid.to_i)
        end
    end
end