require 'csv'
require 'set'
require "csv_tools/version"



module CSVTools


  DEFAULT_CSV_READ_OPTS = {headers: true, skip_blanks: true}


  # @param csv_table [CSV::Table]
  # @param column_index [integer]
  # @return Hash[string --> Array of string-arrays]
  def CSVTools.group_by_column(csv_table, column_index)
    result = {}

    csv_table.group_by {|row| row.fields[column_index]} .each do |key, row_objects|
      result[key] = row_objects.map  do |row|
        row.fields[0...column_index] + row.fields[column_index + 1...row.fields.length]
      end
    end

    return result
  end




  def CSVTools.csv_join(path1, path2, join_by_column, out = STDOUT)
    csv1, csv2 = [path1, path2].map {|p| CSV.read(p, DEFAULT_CSV_READ_OPTS)}

    # Make sure the join-by column exists in both CSV's
    index1, index2 = [csv1, csv2].map {|csv| csv.headers.index(join_by_column) }
    raise "#{path1} does not have a column '#{join_by_column}'" if index1.nil?
    raise "#{path2} does not have a column '#{join_by_column}'" if index2.nil?

    # Print the header line (join-by column is first, and appears only once)
    h1, h2 = [csv1.headers , csv2.headers]
    h1.delete_at(index1)
    h2.delete_at(index2)
    out.puts join_by_column + ',' + h1.join(",") + ',' + h2.join(',')

    # Print the data rows ...
    hash1 = group_by_column(csv1, index1)
    hash2 = group_by_column(csv2, index2)

    # And now ... JOIN the two CSV's (adding nil's for missing rows)
    (hash1.keys + hash2.keys).to_set.each do |key|
      rows1 = hash1[key] || [ [nil] * (csv1.headers.length - 1)]
      rows2 = hash2[key] || [ [nil] * (csv2.headers.length - 1)]

      rows1.each do |r1|
        rows2.each do |r2|
          out.puts key + ',' + r1.join(',') + ',' + r2.join(',')
        end
      end
    end

  end




  def CSVTools.select_values(values, indices)
    raise "Invalid indices #{indices} for #{values}" if indices.any? {|i| i < 0 || i >= values.length}
    return indices.map {|i| values[i]}
  end


  def CSVTools.csv_select(path, column_indices, out = STDOUT)
    csv = CSV.read(path, DEFAULT_CSV_READ_OPTS)

    out.puts select_values(csv.headers, column_indices).join(',')
    csv.each do |row|
      out.puts select_values(row.fields, column_indices).join(',')
    end
  end


  def CSVTools.csv_filter(path, column_index, field_value, out = STDOUT)
    csv = CSV.read(path, DEFAULT_CSV_READ_OPTS)

    out.puts csv.headers.join(',')
    csv.select {|row| row.fields[column_index].downcase.include? field_value.downcase} .each do |row|
      out.puts row.fields.join(',')
    end
  end

end
