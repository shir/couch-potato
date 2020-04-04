# frozen_string_literal: true

# == Schema Information
#
# Table name: accounts
#
#  id         :bigint           not null, primary key
#  currency   :string           not null
#  hidden     :boolean          default(FALSE), not null
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_accounts_on_hidden  (hidden)
#
class Account < ApplicationRecord
  CURRENCIES = %w[RUB USD].freeze

  has_many :balances, inverse_of: :account, dependent: :destroy

  validates :name, presence: true
  validates :currency, presence: true, inclusion: { in: CURRENCIES }

  scope :visible, ->{ where(hidden: false) }

  def to_s
    "#{name} (#{currency})"
  end
end
