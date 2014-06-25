Chart = require 'chartjs'

pieData = [
  {
    value: 40
    color: "#E5F04C"
  }
  {
    value: 20
    color: "#C0D23E"
  }
  {
    value: 10
    color: "#E15E32"
  }
  {
    value: 30
    color: '#A82743'
  }
]

myPie = new Chart(document.getElementById("canvas").getContext("2d")).Doughnut(pieData)