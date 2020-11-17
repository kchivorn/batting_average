#!/usr/bin/env ruby
require 'csv'
require 'docopt'
require 'json'
require_relative 'batting_helper'

doc = <<~DOCOPT
  Average Batting.

  Usage:
    #{__FILE__} [--year=<year>] [--team=<team>]
    #{__FILE__} -h | --help
    #{__FILE__} --version

  Options:
    -h --help     Show this screen.
    --version     Show version.
    --year=<year> Year the game was in.
    --team=<team> Team name the player is in.
DOCOPT

argv = Docopt.docopt(doc)
year_id = argv['--year']
team_id = argv['--team']

start = Time.now
puts "time started at: #{start}"

batting_file = File.read('./batting.json')
batting_json = JSON.parse(batting_file)
batting = []
if batting_json.nil? || batting_json.empty?
  batting = CSV.parse(File.read('Batting.csv'), headers: true, converters: :numeric)
end

res = if batting_json.empty?
        batting_avg_from_csv(batting, team_id, year_id)
      else
        batting_avg_from_json(batting_json, team_id, year_id)
end

print(res)
ended = Time.now
puts "time ended at: #{ended}"
puts "duration: #{ended - start}"


# File.open("batting.json", "w") do |f|
#   f.write(res.to_json)
# end