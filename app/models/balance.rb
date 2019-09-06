# frozen_string_literal: true

class Balance < ApplicationRecord
  belongs_to :account, inverse_of: :balances

  validates :account, presence: true
  validates :date, presence: true

  monetize :amount_cents, with_model_currency: :currency

  delegate :currency, to: :account, allow_nil: true
end
