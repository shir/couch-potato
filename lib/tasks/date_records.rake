# frozen_string_literal: true

namespace :date_records do
  desc 'Recalculate total amounts for all date records'
  task recalculate_amounts: :environment do
    DateRecord.find_each(&:recalculate_total_amounts)
  end
end
