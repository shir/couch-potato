require 'csv'

class ImportRates < BaseService
  attr_accessor :filename

  def initialize(filename)
    @filename = filename
  end

  def perform
    CSV.foreach(filename, headers: true, col_sep: ';') do |row|
      date = Date.parse(row['Date'])
      row.each do |column, value|
        next if column == 'Date'
        next if value.blank?

        rate = ExchangeRate.find_or_initialize_by(date: date)
        rate.rates[column] = parse_rate(value)
        rate.save!
      end
    end
  end

  private

  def parse_rate(value)
    value.tr(',', '.').to_f
  end
end
