require 'csv'
require 'json'

def mapping
  teams = CSV.parse(File.read(File.join(File.dirname(__FILE__), '..', 'csv', 'Teams.csv')), headers: true, converters: :numeric)

  name_to_id = {}
  id_to_name = {}
  teams.each do |team|
    if name_to_id[team['name']].nil?
      name_to_id[team['name']] = [team['teamID'], [team['yearID']]]
    else
      name_to_id[team['name']][1].push(team['yearID'])
    end
    if id_to_name[team['teamID']].nil?
      id_to_name[team['teamID']] = { team['yearID'] => team['name'] }
    else
      id_to_name[team['teamID']][team['yearID']] = team['name']
    end
  end

  File.open(File.join(File.dirname(__FILE__), '..', 'json', 'team_id_to_team_name.json'), 'w') do |f|
    f.write(id_to_name.to_json)
  end

  File.open(File.join(File.dirname(__FILE__), '..', 'json', 'team_name_to_team_id.json'), 'w') do |f|
    f.write(name_to_id.to_json)
  end
end

def get_team_name_to_id
  team_name_to_team_id_file = File.read(File.join(File.dirname(__FILE__), '..', 'json', 'team_name_to_team_id.json'))
  if team_name_to_team_id_file.empty?
    mapping
    team_name_to_team_id_file = File.read(File.join(File.dirname(__FILE__), '..', 'json', 'team_name_to_team_id.json'))
  end
  JSON.parse(team_name_to_team_id_file)
end