require 'csv'

class ImportInstrumentAmounts < BaseService
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

        amount = instrument.amounts.find_or_initialize_by(date: date)
        amount.amount = value
        puts "amount: #{amount.inspect}"
        amount.save!
      end
    end
  end

  private

  def instruments
    @instruments ||= Instrument.all.index_by(&:ticker)
  end
end
