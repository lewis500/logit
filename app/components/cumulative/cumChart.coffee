d3 = require('d3')
Settings = require '../../services/settings'
PlotCtrl = require '../../models/plotCtrl'
Data = require '../../services/data'

template = """
	<svg ng-attr-width='{{::vm.width + vm.mar.left+vm.mar.right}}' ng-attr-height='{{::vm.height + vm.mar.top + vm.mar.bottom}}'>
		<g class='g-main' shifter='{{::[vm.mar.left, vm.mar.top]}}'>
			<rect d3-der='{width: vm.width, height: vm.height}' class='background' />
			<g ver-axis-der width='vm.width' fun='vm.verAxFun' ></g>
			<g hor-axis-der fun='vm.horAxFun' height='vm.height' shifter='{{::[0,vm.height]}}'></g>
			<g class='g-lines'>
				<path class='arr-line'  d3-der='{d: vm.arr_line(vm.minutes)}' />
				<path class='exit-line' d3-der='{d: vm.exit_line(vm.minutes)}' />
				<path class='v-line' d3-der='{d: vm.v_line(vm.minutes)}' />
			</g>
		</g>
	</svg>
"""

class cumCtrl extends PlotCtrl
	constructor: (@scope)->
		super @scope
		@minutes = Data.minutes
		@Ver.domain [0, .05] 
		@Ver2 = @Ver.copy().domain [0,Settings.vf]
		@Hor.domain [0, Settings.num_minutes]

		@arr_line = d3.svg.line()
			.y (d)=> @Ver d.arrivals
			.x (d)=> @Hor d.time 

		@exit_line = d3.svg.line()
			.y (d)=> @Ver d.exits
			.x (d)=> @Hor d.time

		@v_line = d3.svg.line()
			.y (d)=> @Ver2 d.v
			.x (d)=> @Hor d.time
			
der = ->
	directive = 
		controller: ['$scope', cumCtrl]
		controllerAs: 'vm'
		templateNamespace: 'svg'
		template: template
		scope: {}

module.exports = der

