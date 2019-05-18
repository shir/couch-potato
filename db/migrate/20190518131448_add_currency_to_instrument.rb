class AddCurrencyToInstrument < ActiveRecord::Migration[5.2]
  def change
    change_column_null :instruments, :ticker, false
    add_column :instruments, :currency, :string, null: false
  end
end
