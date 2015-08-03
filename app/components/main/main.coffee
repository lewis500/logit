'use strict'
_ = require 'lodash'
d3 = require 'd3'
Data = require '../../services/data'
timeout = require( '../../helpers').timeout
S = require '../../services/settings'
template = '''
	<button ng-click='vm.play()'>Play</button>
	<button ng-click='vm.stop()'>Stop</button>
	<div style='width: 50%'>
		<div layout>
		  <div flex="25" layout layout-align="center center">
		    <span class="md-body-1">u (determinism)</span>
		  </div>
		  <md-slider md-discrete flex min="0.05" max=".8" ng-model="vm.S.u" step='.05'></md-slider>
		</div>

		<div layout>
		  <div flex="25" layout layout-align="center center">
		    <span class="md-body-1">beta</span>
		  </div>
		  <md-slider md-discrete flex min="0.1" max=".8" ng-model="vm.S.beta" step='.05'></md-slider>
		</div>
		<div layout>
		  <div flex="25" layout layout-align="center center">
		    <span class="md-body-1">gamma</span>
		  </div>
		  <md-slider md-discrete flex min="1.2" max="3" ng-model="vm.S.gamma" step='.05'></md-slider>
		</div>
	</div>
'''

		# <div layout>
		#   <div flex="25" layout layout-align="center center">
		#     <span class="md-body-1">R (review rate)</span>
		#   </div>
		#   <md-slider md-discrete flex min="0" max=".2" ng-model="vm.S.R" step='.025'></md-slider>
		# </div>

class Ctrl
	constructor: (@scope)->
		@minutes = Data.minutes
		@paused = false
		@Data = Data
		@S = S

	looper: ->
		timeout =>
			Data.tick()
			@scope.$evalAsync()
			if not @paused then @looper()
			@paused
		, S.interval

	play: ->
		@paused = false
		d3.timer.flush()
		@looper()

	stop: -> @paused = true

der = ->
	directive =
		controller: ['$scope', Ctrl]
		controllerAs: 'vm'
		template: template
		scope: {}


module.exports = der
