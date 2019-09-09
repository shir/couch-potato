# frozen_string_literal: true

class Balance < ApplicationRecord
  belongs_to :account, inverse_of: :balances
  belongs_to :date_record, inverse_of: :balances

  validates :account, presence: true
  validates :date_record, presence: true
  validates :date_record_id, uniqueness: { scope: :account_id }

  monetize :amount_cents, with_model_currency: :currency

  delegate :currency, to: :account, allow_nil: true
end
