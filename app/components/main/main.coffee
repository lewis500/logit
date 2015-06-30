'use strict'
_ = require 'lodash'
d3 = require 'd3'
Data = require '../../services/data'
timeout = require( '../../helpers').timeout
Settings = require '../../services/settings'
template = '''
	<button ng-click='vm.play()'>Play</buton>
	<button ng-click='vm.stop()'>Stop</buton>
'''

class Ctrl
	constructor: (@scope)->
		@minutes = Data.minutes
		@paused = false
		@Data = Data

	looper: ->
		timeout =>
			Data.tick()
			@scope.$evalAsync()
			if not @paused then @looper()
			@paused
		, Settings.interval

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
