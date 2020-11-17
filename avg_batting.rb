#!/usr/bin/env ruby
require 'csv'
require 'docopt'
require 'json'
require_relative 'batting_helper'
require_relative 'avg_batting_json_generator'

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
team_name = argv['--team']
year_ids = []
team_name_to_id = JSON.parse(File.read('./team_name_to_team_id.json'))
# set team id and year in which those team exist (there are many teams with the same id but different names through the years)
team_id = if team_name.nil?
            year_ids = year_id.nil? ? nil : [year_id.to_i]
            nil
          else
            id = team_name_to_id[team_name]
            if id.nil?
              puts "Team name does not exist. Please enter a correct name."
              return
            else
              year_ids = year_id.nil? ? id[1] : [year_id.to_i]
              id[0]
            end
          end

# read average batting json from the file
read_avg_batting(team_id)

batting_json = JSON.parse(batting_file)
res = batting_avg_from_json(batting_json, team_id, year_ids)
print_avg(res)
