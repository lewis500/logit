d3 = require('d3')
Settings = require '../../services/settings'
PlotCtrl = require '../../models/plotCtrl'
Data = require '../../services/data'

template = """
	<svg ng-attr-width='{{::vm.height + vm.top+vm.bottom}}' ng-attr-height='{{::vm.height + vm.mar.top + vm.mar.bottom}}'>
		<g class='g-main' shifter='{{::[vm.mar.left, vm.mar.top]}}'>
			<g y-axis scale='vm.Y' width='vm.width'></g>
			<g ex-axis height='vm.height' scale='vm.X' shifter='{{::[0,vm.height]}}'></g>
			<g class='g-lines'>
				<path class='arr-line' line-der data='vm.minutes' line-fun='vm.lineFun2' watch='vm.watch' />
			</g>
		</g>
	</svg>
"""

class arrCtrl extends PlotCtrl
	constructor: (@scope, @element)->
		super @scope, @element
		@minutes = Data.minutes
		@Y.domain [0, 40]
		@X.domain [0, Settings.num_minutes]
		@lineFun = d3.svg.line()
			.y (d)=> @Y d.arrivals
			.x (d)=> @X d.time
		@lineFun2 = d3.svg.line()
			.y (d)=> @Y d.target_avg
			.x (d)=> @X d.time

		@watch = ()=> 
			res = Data.minutes[100].cum_arrivals

der = ()->
	directive = 
		controller: ['$scope', '$element', arrCtrl]
		controllerAs: 'vm'
		templateNamespace: 'svg'
		template: template
		scope: {}

module.exports = der