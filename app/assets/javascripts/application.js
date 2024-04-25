// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
import "chartkick/chart.js"
import FusionCharts from 'fusioncharts';
import Charts from 'fusioncharts/fusioncharts.charts';
Charts(FusionCharts);