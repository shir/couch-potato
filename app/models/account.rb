# frozen_string_literal: true

class Account < ApplicationRecord
  CURRENCIES = %w[RUB USD].freeze

  validates :name, presence: true
  validates :currency, presence: true, inclusion: { in: CURRENCIES }

  def to_s
    name
  end
end
