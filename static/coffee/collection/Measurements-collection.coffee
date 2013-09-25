define ["backbone", "model/Measurement-model", "event/EventBus-event"], (Backbone, MeasurementModel, EventBus)->
	class MeasurementsCollection extends Backbone.Collection
		model: MeasurementModel
		defaults:
			levels: [
				probability: .80
				minimum: 100
				maximum: 300
			,
				probability: .17
				minimum: 300
				maximum: 400
			,
				probability: .02
				minimum: 400
				maximum: 1200
			,
				probability: .01
				minimum: 1200
				maximum: 1300
			]
		initialize:->
			@eventBus = EventBus
			@levels = @defaults.levels
			@tags = [
				level: 400
				tag: 'normal'
			,
				level: 1200
				tag: 'warning'
			,
				level: 1500
				tag: 'danger'
			];
			@difference = 10
			@_createRanges()
			@measurementInterval = setInterval _.bind(@doMeasure, @), 600
			@cumulativeDose = 0;
			@startTime = new Date().getTime()
		
		reinitialize:->
			@_createRanges

		setLevels:(levels)->
			@levels = levels
			@_createRanges()

		_createRanges:->
			probability = 0
			_.each @levels, (level, key)->
				level.left = if probability == 0 then 0 else probability + 1
				probability += level.probability * 100
				level.right = probability

		newMeasure:->
			range = _.random(0, 100);
			level = _.find @levels, (level)->
				if range >= level.left and range <= level.right
					level

			value = _.random level.minimum, level.maximum

			value += (value * _.random(-@difference, @difference) / 100)

			@add
				value: value
				tag: @getTag value

			@cumulativeDose += @last().get "value"

		doMeasure:->
			lastMeasure = @last()
			if lastMeasure?.get("readiness") < 100
				lastMeasure.set "readiness", lastMeasure.get("readiness") + 20
			else
				@newMeasure()

			lastMeasure = @last()
			lastReadiness = @last().get "readiness"

			switch @getTag lastMeasure.get "value"
				when 'warning'
					@eventBus.trigger "device.beep" if _.random(0, 100) > 70 
				when 'danger'
					@eventBus.trigger "device.beep" if _.random(0, 100) > 20 
				else
					@eventBus.trigger "device.beep" if (lastReadiness is 20 or lastReadiness is 60) and _.random(0, 100) > 90
		
		getTag:(value)->
			level = _.find @tags, (item)->
				value <= item.level
			level?.tag or 'danger'

		getTagMaxValue:(tag)->
			level = _.find @tags, (item)->
				tag == item.tag
			level?.level or 0

	new MeasurementsCollection