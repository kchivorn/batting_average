require 'csv'
require 'json'

def mapping
  teams = CSV.parse(File.read('Teams.csv'), headers: true, converters: :numeric)

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

  File.open('team_id_to_team_name.json', 'w') do |f|
    f.write(id_to_name.to_json)
  end

  File.open('team_name_to_team_id.json', 'w') do |f|
    f.write(name_to_id.to_json)
  end
end
mapping