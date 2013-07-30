define ["backbone", "model/Measurement-model"], (Backbone, MeasurementModel)->
	class MeasurementsCollection extends Backbone.Collection
		model: MeasurementModel
		initialize:->
			@measurementInterval = setInterval _.bind(@doMeasure, @), 500
			@cumulativeDose = 0;

		doMeasure:->
			eValue = _.random(0, 1000)
			mValue = _.random(0, 100)
			@add
				e: 
					x: eValue + _.random(-50, 50)
					y: eValue + _.random(-50, 50)
				m:
					x: mValue + _.random(-50, 50)
					y: mValue + _.random(-50, 50)
					z: mValue + _.random(-50, 50)

	new MeasurementsCollection