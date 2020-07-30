#!/usr/bin/env ruby

# Assumes you have exported clustering results from OpenRefine as JSON files
#  and that these files are all in one directory
#  and that these are the only JSON files in that directory
# Spits out a basic text file reformatting the basic info from the JSON files into an
#  easily human-readable format suitable for passing to clients to inform
#  data remediation
# Output text file is saved in the JSON directory

require 'json'
require 'optparse'

options = {}
OptionParser.new do |opts|
  opts.banner = 'Usage: format_clusters.rb -i path-to-input-dir -o output-file-name'

  opts.on('-i', '--input PATH', 'Path to input directory containing JSON files') do |i|
    options[:input] = File.expand_path(i)
  end

  opts.on('-o', '--output STRING', 'Filename for output text file') do |o|
    options[:output] = o
  end

  opts.on('-h', '--help', 'Prints this help') do
    puts opts
    exit
  end
end.parse!

jsonfiles = Dir.children(options[:input])
  .select{ |name| name.downcase.end_with?('.json') }
  .map{ |name| "#{options[:input]}/#{name}" }

File.open("#{options[:input]}/#{options[:output]}", 'wb') do |f|
  jsonfiles.each do |jf|
    j = JSON.parse(File.read(jf))

    f.puts "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"
    f.puts "Clustering method: #{j['clusterMethod']}"
    f.puts "Keying function: #{j['keyingFunction']}"
    f.puts "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"
    f.puts ''
    j['clusters'].each{ |cluster|
      cluster['choices'].each{ |choice|
        f.puts choice['v']
      }
      f.puts ''
    }
  end
end

