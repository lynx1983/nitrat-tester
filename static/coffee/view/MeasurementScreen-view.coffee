define [
	"view/TemplatedScreen-view"
	"model/DeviceSettings-model"
	"collection/Measurements-collection"
	"i18n/i18n"
	], (TemplatedScreenView, DeviceSettings, Measurements, i18n)->
	class MeasurementScreenView extends TemplatedScreenView
		initialize:->
			@template = _.template $(@options.template).html()
			@tag = ''

		render:->
			lastValue = Measurements.last()
			value = lastValue.get "value"
			if DeviceSettings.get("unit") is "sievert"
				value /= 1000
			else
				value /= 100
			value = value.toFixed(2).replace ".", ","

			level = DeviceSettings.get "threshold"
			if DeviceSettings.get("unit") is "sievert"
				level /= 1000
			else
				level /= 100
			level = level.toFixed(2).replace ".", ","

			@$el.html @template
				t: i18n.t
				title: @title
				unit: if DeviceSettings.get("unit") is "sievert" then "mcSv/h" else "mcR/h"
				value: value
				level: level
			@

		activate:->
			super
			console.log "Screen [#{@name}] custom activate"
			Measurements.on "add change", @render, @

		deactivate:->
			super			
			console.log "Screen [#{@name}] custom deactivate"
			Measurements.off "add change", @render, @