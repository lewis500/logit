d3 = require 'd3'
Settings = require '../services/settings'
require '../helpers'
_ = require 'lodash'


class Memory
	constructor: ->
		@array = []
	remember: (c)->
		@array.push c
		if @array.length > 1 then @array.shift()
	val: ->
		d3.mean @array

class Memories
	constructor: ()->
		@map = d3.map()

	remember: (arr_time, cost)->
		if @map.has arr_time
			@map.get arr_time
				.remember cost
		else
			newMem = new Memory
			@map.set arr_time , newMem
			newMem.remember cost 

	min: ->
		c = Infinity
		candidates = []
		@map.forEach (time, memory)->
			cost= memory.val()
			if cost < c
				c = cost
				candidates = []
				candidates.push +time
			else if cost == c
				candidates.push +time
		if candidates.length > 0 then _.sample(candidates ) else 5

class Car 
	constructor: (@n, @tar_time)->
		@sched_pen = Infinity
		@cost = Infinity
		@travel_pen = Infinity
		@exit_time = Infinity
		@memories = new Memories
		@is_sampled = false
		@path = []

	exit:(time)-> 
		@exit_time = time
		@travel_pen = @exit_time - @actual_time
		sched_del = @exit_time - Settings.wish_time
		@sched_pen = Math.max(-Settings.beta * sched_del, Settings.gamma * sched_del)
		@cost = @travel_pen + @sched_pen
		@memories.remember @actual_time , @cost

	choose: ()->
		@tar_time = @memories.min()

	guesser: d3.random.normal(0,2)
	# guesser: ->
	# 	_.sample [-3..3]

	arrive: ->
		# a = @tar_time + d3.random.normal(0,15)()
		e = if Math.random() < .3 then 0 else Math.floor @guesser()
		a = @tar_time + e
		res = Math.max 1 , Math.min( a, Settings.num_minutes - 1)
		@actual_time = res
		res

module.exports = Car