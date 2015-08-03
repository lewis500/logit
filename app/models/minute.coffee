S = require '../services/settings'
require '../helpers.coffee'

V = (k)->
	S.vf*(1-k/S.kj) 

blank = 
	pass_k: -> 
	cum_arrivals: 0
	cum_exits: 0

class Minute 
	constructor: (@time)->
		@k = 0
		@arrivals = 0
		@exits = 0
		@cum_arrivals = 0
		@cum_exits = 0
		@exits = 0
		@next = undefined
		@prev = undefined
		@delta = S.wish_time - @time
		# @sp = Math.max delta*S.beta, -delta*S.gamma
		# @calc_cost()

	set_next: (d)-> 
		@next = d ? blank

	set_prev: (d)->
		@prev = d ? blank

	serve: ->
		@v = V @k
		@exits = @k * @v / S.L
		@next.pass_k (@k-@exits)
		@cum_exits = @prev.cum_exits + @exits
		@cum_arrivals = @prev.cum_arrivals + @arrivals

	pass_k: (k)-> @k += k

	calc_cost: ->
		sp = Math.max @delta*S.beta, -@delta*S.gamma
		if @time == ( S.num_minutes-1)
			@c = S.alpha * S.L / @v + sp
		else
			dt = 1
			p = @v/S.L * dt
			@c = p*sp + (1-p)*(S.alpha * dt + @next.c)
		# @c = S.alpha *

	choose: (denominator) ->
		util = -S.u*@c
		@arrivals = @arrivals * (1-S.R)*S.N + S.R * S.N * Math.exp(util) / denominator

	reset: ->
		@k = @arrivals
		# @arrivals = undefined
		@exits = undefined
		@v = undefined
		@c = undefined

module.exports = Minute