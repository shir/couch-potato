class MovePriceToAmount < ActiveRecord::Migration[5.2]
  def change
    rename_column :instrument_amounts, :amount, :count
    add_monetize :instrument_amounts, :price, currency: { present: false }

    reversible do |dir|
      dir.up do
        InstrumentAmount.reset_column_information

        InstrumentPrice.preload(:instrument).find_each do |price|
          amount = price.instrument.amounts.find_or_initialize_by(date: price.date) do |a|
            a.count = 0
          end
          amount.price = price.price
          amount.save!
        end
      end
    end
  end
end
