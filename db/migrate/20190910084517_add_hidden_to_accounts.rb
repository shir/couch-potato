# frozen_string_literal: true

class AddHiddenToAccounts < ActiveRecord::Migration[5.2]
  def change
    add_column :accounts, :hidden, :boolean, null: false, default: false

    add_index :accounts, :hidden
  end
end
