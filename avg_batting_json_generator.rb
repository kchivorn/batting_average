require_relative 'batting_helper'
require 'csv'

def generate_stint
  batting = CSV.parse(File.read('Batting.csv'), headers: true, converters: :numeric)
  res_stint = get_avg_for_each_stint(batting)

  File.open('batting_each_stint.json', 'w') do |f|
    f.write(res_stint.to_json)
  end
end

def generate_without_stint
  batting = CSV.parse(File.read('Batting.csv'), headers: true, converters: :numeric)
  res = get_all_avg(batting)
  File.open('batting.json', 'w') do |f|
    f.write(res.to_json)
  end
end

def generate_all
  batting = CSV.parse(File.read('Batting.csv'), headers: true, converters: :numeric)
  res_stint = get_avg_for_each_stint(batting)

  File.open('batting_each_stint.json', 'w') do |f|
    f.write(res_stint.to_json)
  end

  res = get_all_avg(batting)
  File.open('batting.json', 'w') do |f|
    f.write(res.to_json)
  end
end

def read_avg_batting(team_id)
  if team_id.nil?
    batting_file = File.read('./batting.json')
    if batting_file.empty?
      generate_without_stint
      batting_file = File.read('./batting.json')
    end
  else
    batting_file = File.read('./batting_each_stint.json')
    if batting_file.empty?
      generate_stint
      batting_file = File.read('./batting_each_stint.json')
    end
  end
end

generate_all