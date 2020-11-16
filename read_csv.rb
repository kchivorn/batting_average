require 'csv'

def output_with_team_id(batting, team_id)
  res = []
  batting.each do |b|
    next unless b[3] == team_id

    res.push([b[0], b[1], b[3], b[6] != 0 ? b[8] / b[6].to_f : 0])
  end
  res
end

def output_with_team_id_and_year_id(batting, team_id, year_id)
  res = []
  start = false
  batting.each do |b|
    break if start && b[1] != year_id.to_i
    next unless (b[3] == team_id) && (b[1] == year_id.to_i)

    res.push([b[0], b[1], b[3], b[6] != 0 ? b[8] / b[6].to_f : 0])
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
    if raw[b[0]].nil?
      raw[b[0]] = { b[1] => [b[0], b[1], [b[3]], [b[8]], [b[6]]] }
    elsif raw[b[0]][b[1]].nil?
      raw[b[0]][b[1]] = [b[0], b[1], [b[3]], [b[8]], [b[6]]]
    else
      raw[b[0]][b[1]][2].push(b[3])
      raw[b[0]][b[1]][3].push(b[8])
      raw[b[0]][b[1]][4].push(b[6])
    end
    start = true
  end

  res = []
  raw.each_value do |v|
    v = v[year_id.to_i]
    res.push([v[0], v[1], v[2].join(","), v[3].sum / v[4].sum.to_f])
  end
  res
end

def output_all(batting)
  raw = {}
  batting.each do |b|
    if raw[b[0]].nil?
      raw[b[0]] = { b[1] => [b[0], b[1], [b[3]], [b[8]], [b[6]]] }
    elsif raw[b[0]][b[1]].nil?
      raw[b[0]][b[1]] = [b[0], b[1], [b[3]], [b[8]], [b[6]]]
    else
      raw[b[0]][b[1]][2].push(b[3])
      raw[b[0]][b[1]][3].push(b[8])
      raw[b[0]][b[1]][4].push(b[6])
    end
  end

  res = []
  raw.each_value do |v|
    v = v.values[0]
    res.push([v[0], v[1], v[2].join(","), v[3].sum / v[4].sum.to_f])
  end
  res
end


year_id = nil
team_id = nil

batting = CSV.parse(File.read('Batting.csv'), headers: true, converters: :numeric)
res = []

res = if !year_id.nil? && !team_id.nil?
        output_with_team_id_and_year_id(batting, team_id, year_id)
      elsif !year_id.nil?
        output_with_year_id(batting, year_id)
      elsif !team_id.nil?
        output_with_team_id(batting, team_id)
      else
        output_all(batting)
      end

print(res)