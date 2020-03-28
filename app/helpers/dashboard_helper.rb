# frozen_string_literal: true

module DashboardHelper
  def total_chart_annotation_options(total_chart)
    annotations = total_chart.rebalances.map do |date|
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
