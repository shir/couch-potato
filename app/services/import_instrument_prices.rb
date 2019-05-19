require 'csv'

class ImportInstrumentPrices < BaseService
  attr_accessor :filename

  def initialize(filename)
    @filename = filename
  end

  def perform
    CSV.foreach(filename, headers: true, col_sep: ';') do |row|
      date = Date.parse(row['Date'])
      puts "date: #{date.inspect}"
      row.each do |column, value|
        next if value.blank?

        instrument = instruments[column]
        next unless instrument
        puts "instrument: #{instrument.inspect}"

        price = instrument.prices.find_or_initialize_by(date: date)
        price.price = parse_price(value)
        price.save!
      end
    end
  end

  private

  def instruments
    @instruments ||= Instrument.all.index_by(&:ticker)
  end

  def parse_price(value)
    Monetize.parse(value.gsub('US$', 'USD'))
  end
end
