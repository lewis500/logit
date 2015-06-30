S = require './settings'
Minute = require '../models/minute'
_ = require 'lodash'

class Data
	constructor: ()->
		@minutes = [0...S.num_minutes].map (time)=> 
				newMinute = new Minute time

		@minutes.forEach (m,i,k)->
			m.set_prev k[i-1]
			m.set_next k[i+1]

		@minutes.forEach (m)->
			m.arrivals = S.N*1/S.num_minutes

	tick: ->
		# physics stage
		@minutes.forEach (m)->m.reset()
		@minutes.forEach (m)-> m.serve()
		_.forEachRight @minutes, (m)-> m.calc_cost()
		denominator = d3.sum @minutes, (m)->
			util = -m.c*S.u
			res = Math.exp util
		@minutes.forEach (m)-> m.choose denominator


module.exports = new Data()
