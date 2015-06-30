
mean = require( 'd3').mean


class Queue 
	constructor: (@length, @accessor)->	@queue = []

	add: (val)->
		if @queue.length >= @length then @queue.unshift()
		@queue.push(val)

	avg: ->d3.mean(@queue, @accessor)

	reset: -> @queue = []

module.exports = Queue