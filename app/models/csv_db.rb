require 'csv'
class CsvDb
  class << self
    def convert_save(target_model, csv_data, current_user, &block)
      csv_file = csv_data.read
      line_count = %x(wc -l #{filename}).to_i
      CSV.parse(csv_file, headers: true, header_converters: :symbol).each_with_index do |row, line_num|
        data = row.to_hash
        is_last_row = (line_num == line_count)
        if data.present?
          if (block_given?)
             block.call(target_model, data, is_last_row, current_user)
           else
             target_model.create!(data)
           end
         end
      end
    end
  end
end
