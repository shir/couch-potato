# frozen_string_literal: true

class CollectPurchases < BaseService
  def perform
    DateRecord.where(rebalance: true).find_each do |dr|
      collect_for_date_record(dr)
    end
  end

  private

  def collect_for_date_record(date_record)
    date_record.instrument_amounts.includes(:instrument).each do |ia|
      date_record.purchases
        .find_or_initialize_by(instrument: ia.instrument).tap do |purchase|
        purchase.count = ia.count - (ia.prev&.count || 0)
        purchase.price = ia.price
        purchase.save
      end
    end
  end
end
