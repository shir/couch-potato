# frozen_string_literal: true

module DashboardHelper
  def chart_rebalances_options(chart)
    annotations = chart.rebalances.map do |date|
      {
        type:        'line',
        mode:        'vertical',
        scaleID:     'x-axis-0',
        value:       date,
        borderColor: 'LightGray',
        borderDash:  [2, 5],
      }
    end

    {
      annotation: {
        annotations: annotations,
      },
    }
  end
end
