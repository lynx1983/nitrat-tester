define ["backbone", "model/Measurement-model"], (Backbone, MeasurementModel)->
	class MeasurementsCollection extends Backbone.Collection
		model: MeasurementModel
		initialize:->
			@reset()			
			@measurementInterval = setInterval _.bind(@doMeasure, @), 500

		reset:->
			@eValue = _.random(0, 1000)
			@mValue = _.random(0, 80)

		doMeasure:->
			eValueRange = @eValue / 10
			mValueRange = @mValue / 10
			@add
				e: 
					x: @eValue + _.random(-eValueRange, eValueRange)
					y: @eValue + _.random(-eValueRange, eValueRange)
				m:
					x: @mValue + _.random(-mValueRange, mValueRange)
					y: @mValue + _.random(-mValueRange, mValueRange)
					z: @mValue + _.random(-mValueRange, mValueRange)

	new MeasurementsCollection