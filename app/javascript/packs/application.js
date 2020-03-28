import Rails from 'rails-ujs';
import Turbolinks from 'turbolinks';
import 'bootstrap';
import Chartkick from 'chartkick';
import Chart from 'chart.js';
import ChartAnnotationsPlugin from 'chartjs-plugin-annotation';

import '../stylesheets/application.scss';

Rails.start();
Turbolinks.start();

window.Chartkick = Chartkick;
Chart.plugins.register(ChartAnnotationsPlugin);
Chartkick.addAdapter(Chart);

$(document).on('turbolinks:load', () => {
  $('[data-toggle="tooltip"]').tooltip();
})
