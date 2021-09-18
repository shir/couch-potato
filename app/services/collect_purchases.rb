# frozen_string_literal: true

class CollectPurchases < BaseService
  attr_reader :force

  def initialize(force: false)
    @force = force
  end

  def perform
    if force
      # If SPLIT was added then we have to recalculate all purchases
      # for that insrumet
      puts 'Force recalculating purchases'
      Purchase.destroy_all
    end

    DateRecord.find_each do |dr|
      collect_for_date_record(dr)
    end
  end

  private

  def collect_for_date_record(date_record)
    date_record.instrument_amounts.includes(:instrument).each do |ia|
      prev_ia = ia.prev
      next if prev_ia && prev_ia.absolute_count == ia.absolute_count

      date_record.purchases
        .find_or_initialize_by(instrument: ia.instrument).tap do |purchase|
        purchase.count = ia.absolute_count - (prev_ia&.absolute_count || 0)
        purchase.price = ia.absolute_price
        purchase.save
      end
    end
  end
end
