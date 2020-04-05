# frozen_string_literal: true

namespace :date_records do
  desc 'Recalculate total amounts for all date records'
  task recalculate_amounts: :environment do
    DateRecord.find_each(&:recalculate_total_amounts)
  end

  desc 'Recalculate profits for all date records'
  task recalculate_profits: :environment do
    CollectPurchases.perform
    DateRecord.find_each(&:recalculate_profits)
  end

  desc 'Recalculate all calculated values for all date records'
  task update_calculations: :environment do
    CollectPurchases.perform

    DateRecord.find_each do |date_record|
      UpdateDateRecordCalculations.perform(date_record)
    end
  end
end
