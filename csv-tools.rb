#!/usr/bin/env ruby

require 'csv'


# @param csv_obj [CSV::Table]
# @param key_column_index [integer]
# @return Hash[string --> Array of strings] Each row in csv_obj is an entry in the returned hash.
def csv2hash(csv_obj, key_column_index)
  result = {}
  csv_obj.each do |row|
    key = row.fields[key_column_index]
    values = row.fields[0...key_column_index] + row.fields[key_column_index + 1...row.fields.length]
    raise "Duplicate key '#{key}' in #{csv_obj}" if result.has_key? key
    result[key] = values
  end
  return result
end


def csv_join(path1, path2, join_by_column, out = STDOUT)
  csv1, csv2 = [path1, path2].map {|p| CSV.read(p, {headers: true})}

  # Make sure the join-by column exists in both CSV's
  index1, index2 = [csv1, csv2].map {|csv| csv.headers.index(join_by_column) }
  raise "#{path1} does not have a column '#{join_by_column}'" if index1.nil?
  raise "#{path2} does not have a column '#{join_by_column}'" if index2.nil?

  h1, h2 = [csv1.headers , csv2.headers]
  h1.delete_at(index1)
  h2.delete_at(index2)
  out.puts join_by_column + ',' + h1.join(",") + ',' + h2.join(',')

  hash1 = csv2hash(csv1, index1)
  hash2 = csv2hash(csv2, index2)

  hash1.each do |key, values1|
    values2 = hash2[key] || ([nil] * (csv2.headers.length - 1))
    out.puts key + ',' + values1.join(',') + ',' + values2.join(',')
  end

  # Process entries in csv2 that are not in csv1
  hash2.reject {|k, _| hash1.has_key? k} .each do |key, values2|
    values1 = hash1[key] || ([nil] * (csv1.headers.length - 1))
    out.puts key + ',' + values1.join(',') + ',' + values2.join(',')
  end
end





if ARGV.length != 3
  abort("Usage: #{File.basename($0)} CSV-FILE1 CSV-FILE2 JOIN-BY-COLUMN")
end

csv_join(ARGV[0], ARGV[1], ARGV[2])
