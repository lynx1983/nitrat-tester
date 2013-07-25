define ["backbone"], (Backbone)->
	class MeasurementModel extends Backbone.Model
		defaults:->
			value: 0
			readiness: 0
			tag: 'normal'

	MeasurementModel