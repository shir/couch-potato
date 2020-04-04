# frozen_string_literal: true

# == Schema Information
#
# Table name: instruments
#
#  id         :bigint           not null, primary key
#  ticker     :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  currency   :string           not null
#  hidden     :boolean          default(FALSE), not null
#
class Instrument < ApplicationRecord
  CURRENCIES = %w[USD RUB].freeze

  has_many :amounts, class_name: 'InstrumentAmount',
    inverse_of: :instrument, dependent: :restrict_with_error
  has_many :purchases, inverse_of: :instrument, dependent: :destroy

  validates :ticker, presence: true
  validates :currency, presence: true, inclusion: { in: CURRENCIES }

  scope :visible, ->{ where(hidden: false) }

  def to_s
    ticker
  end
end
