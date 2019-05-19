class InstrumentAmount < ApplicationRecord
  belongs_to :instrument, inverse_of: :amounts

  validates :instrument, presence: true
  validates :amount, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
