Chart = require 'chartjs'

pieData = [
  {
    value: 30
    color: "#E15E32"
  }
  {
    value: 50
    color: "#C0D23E"
  }
  {
    value: 100
    color: "#E5F04C"
  }
]
myPie = new Chart(document.getElementById("canvas").getContext("2d")).Pie(pieData)