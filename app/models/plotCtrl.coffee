angular = require 'angular'
_ = require 'lodash'
class PlotCtrl
	constructor: (@scope) ->
		@width = 450
		@height = 300
		@Ver = d3.scale.linear()
			.domain [0,8]
			.range [@height, 0]

		@Hor = d3.scale.linear()
			.domain [0,8]
			.range [0, @width]

		@horAxFun = d3.svg.axis()
			.scale @Hor
			.ticks 5
			.orient 'bottom'

		@verAxFun = d3.svg.axis()
			.scale @Ver
			.ticks 5
			.orient 'left'

		@mar = 
			left: 30
			top: 20
			right: 10
			bottom: 30

module.exports = PlotCtrl