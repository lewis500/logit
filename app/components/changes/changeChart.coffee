d3 = require('d3')
Settings = require '../../services/settings'
PlotCtrl = require '../../models/plotCtrl'
Data = require '../../services/data'

template = """
	<svg width='100%' ng-attr-height='{{vm.height + vm.mar.top + vm.mar.bottom}}' ng-init='vm.resize()'>
		<g class='g-main' shifter='{{[vm.mar.left, vm.mar.top]}}'>
			<g y-axis scale='vm.Y' width='vm.width'></g>
			<g ex-axis height='vm.height' scale='vm.X' shifter='{{[0,vm.height]}}'></g>
			<g>
				<g ng-repeat='car in vm.cars'>
					<path class='path-choice'></path>
				</g>
			</g>
		</g>
	</svg>
"""

class changeCtrl extends PlotCtrl
	constructor: (@scope, @element)->
		super(@scope, @element)
		@cars = Data.cars
		@Y.domain([0, 220])
		@X.domain([0, Settings.num_minutes])
		@lineFun = d3.svg.line()
			.y (d)=> @Y(d.cost)
			.x (d)=> @X(d.time)

		@watch = ()=> 
			res = Data.minutes[100].cum_arrivals

der = ()->
	directive = 
		controller: ['$scope', '$element', changeCtrl]
		controllerAs: 'vm'
		templateNamespace: 'svg'
		template: template
		scope: {}

module.exports = der