class CreateBalances < ActiveRecord::Migration[5.2]
  def change
    create_table :balances do |t|
      t.date :date, null: false
      t.references :account, foreign_key: true, null: false
      t.monetize :amount, null: false, default: 0

      t.timestamps
    end
  end
end
