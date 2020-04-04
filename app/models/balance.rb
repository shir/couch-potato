# frozen_string_literal: true

# == Schema Information
#
# Table name: balances
#
#  id              :bigint           not null, primary key
#  amount_cents    :integer          default(0), not null
#  amount_currency :string           default("USD"), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  account_id      :bigint           not null
#  date_record_id  :bigint           not null
#
# Indexes
#
#  index_balances_on_account_id      (account_id)
#  index_balances_on_date_record_id  (date_record_id)
#
class Balance < ApplicationRecord
  belongs_to :account, inverse_of: :balances
  belongs_to :date_record, inverse_of: :balances

  validates :account, presence: true
  validates :date_record, presence: true
  validates :date_record_id, uniqueness: { scope: :account_id }

  monetize :amount_cents, with_model_currency: :currency

  delegate :currency, to: :account, allow_nil: true
end
