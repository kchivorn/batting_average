require 'json'
def output_with_team_id(batting, team_id)
  res = []
  batting.each do |b|
    next unless b[3] == team_id

    res.push([b[0], b[1], b[3], b[6].zero? ? 0 : b[8] / b[6].to_f])
  end
  res
end

def output_with_team_id_and_year_id(batting, team_id, year_id)
  res = []
  start = false
  batting.each do |b|
    break if start && b[1] != year_id.to_i
    next unless (b[3] == team_id) && (b[1] == year_id.to_i)

    res.push([b[0], b[1], b[3], b[6].nil? || b[6].zero? ? b[6] : b[8] / b[6].to_f])
    start = true
  end
  res
end

def output_with_year_id(batting, year_id)
  raw = {}
  start = false
  batting.each do |b|
    break if start && b[1] != year_id.to_i
    next unless b[1] == year_id.to_i

    sum_batting(raw, b)
    start = true
  end

  res = []
  raw.each_value do |v|
    v = v[year_id.to_i]
    ab = v[4].sum
    res.push([v[0], v[1], v[2].join(','), ab.zero? ? ab : v[3].sum / ab.to_f])
  end
  res
end

def output_all(batting)
  raw = {}
  batting.each do |b|
    sum_batting(raw, b)
  end

  res = []
  raw.each_value do |v|
    v = v.values[0]
    ab = v[4].sum
    res.push([v[0], v[1], v[2].join(','), ab.zero? ? ab : v[3].sum / ab.to_f])
  end
  res
end

def sum_batting(raw, batting)
  if raw[batting[0]].nil?
    raw[batting[0]] = { batting[1] => [batting[0], batting[1], [batting[3]], [batting[8]], [batting[6]]] }
  elsif raw[batting[0]][batting[1]].nil?
    raw[batting[0]][batting[1]] = [batting[0], batting[1], [batting[3]], [batting[8]], [batting[6]]]
  else
    raw[batting[0]][batting[1]][2].push(batting[3])
    raw[batting[0]][batting[1]][3].push(batting[8])
    raw[batting[0]][batting[1]][4].push(batting[6])
  end
end

def batting_avg_from_csv(batting, team_id, year_id)
  if !year_id.nil? && !team_id.nil?
    output_with_team_id_and_year_id(batting, team_id, year_id)
  elsif !year_id.nil?
    output_with_year_id(batting, year_id)
  elsif !team_id.nil?
    output_with_team_id(batting, team_id)
  else
    output_all(batting)
  end
end

def output_with_team_id_and_year_id_json(batting, team_id, year_id)
  batting.select { |b| b[1] == year_id.to_i && b[2] == team_id }
end

def output_with_year_id_json(batting, year_id)
  batting.select { |b| b[1] == year_id.to_i }
end

def output_with_team_id_json(batting, team_id)
  batting.select { |b| b[2] == team_id }
end

def output_all_json(batting)
  batting
end

def batting_avg_from_json(batting, team_id, year_id)
  if !year_id.nil? && !team_id.nil?
    output_with_team_id_and_year_id_json(batting, team_id, year_id)
  elsif !year_id.nil?
    output_with_year_id_json(batting, year_id)
  elsif !team_id.nil?
    output_with_team_id_json(batting, team_id)
  else
    output_all_json(batting)
  end
end