require 'roo'
class XlsDb
  class << self
    def convert_save(target_model, xls_data, &block)
      xls = Roo::Spreadsheet.open(xls_data)
      default_sheet = xls.sheet(0)
      header = parse_header(default_sheet.row(1))
      (2..default_sheet.last_row).each do |line|
        data = Hash[header.zip default_sheet.row(line)]
        last_row = (line == default_sheet.last_row)
        if data.present?
          if (block_given?)
            block.call(target_model, data, last_row)
           else
            target_model.create!(data)
          end
        end
      end
    end

    def parse_header(row)
      row.map(&:parameterize).map(&:underscore).map(&:to_sym)
    end
  end
end
