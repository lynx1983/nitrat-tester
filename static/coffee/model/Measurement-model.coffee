define ["backbone"], (Backbone)->
	class MeasurementModel extends Backbone.Model
		defaults:->
			e:
				x: 0
				y: 0
			m:
				x: 0
				y: 0
				z: 0

	MeasurementModel