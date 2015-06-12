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
			@lastValue = ''
			@accuracy = 0
			@maxAccuracy = 12

		render:->
			lastValue = Measurements.last()
			readiness = lastValue.get "readiness"
			if readiness isnt 100 
				value = @lastValue
			else
				value = lastValue.get "value"
				@accuracy++ unless @accuracy >= @maxAccuracy
				@lastValue = value
			
			if DeviceSettings.get("unit") is "sievert"
				formattedValue = value / 1000
			else
				formattedValue = value / 100
			
			formattedValue = formattedValue.toFixed(2).replace ".", ","
			
			level = DeviceSettings.get "threshold"
			if DeviceSettings.get("unit") is "sievert"
				level /= 1000
			else
				level /= 100
			level = level.toFixed(2).replace ".", ","

			tag = Measurements.getTag value

			switch tag
				when 'warning'
					msg = 'High radiation background'
				when 'danger'
					msg = 'Dangerous radiation background'
				else
					msg = 'Normal radiation background'

			@$el.html @template
				t: i18n.t
				title: @title
				unit: if DeviceSettings.get("unit") is "sievert" then "mcSv/h" else "mcR/h"
				value: formattedValue
				level: level
				readiness: readiness
				accuracy: 100 / @maxAccuracy * @accuracy
				tag: tag
				msg: msg
			@

		activate:->
			super
			console.log "Screen [#{@name}] custom activate"
			@accuracy = 0
			Measurements.on "add change", @render, @
			@eventBus.on "button.click", @onButtonClick, @
			@eventBus.trigger "device.button.setState", "left", "disabled"
			@eventBus.trigger "device.button.setState", "right", "disabled"
			@eventBus.trigger "device.button.setState", "center", "Menu"

		deactivate:->
			super			
			console.log "Screen [#{@name}] custom deactivate"
			Measurements.off "add change", @render, @
			@eventBus.off "button.click", @onButtonClick, @
			@eventBus.trigger "device.button.removeState", "left", "disabled"
			@eventBus.trigger "device.button.removeState", "right", "disabled"

		onButtonClick:(button)->
			console.log "Get event by screen [#{@name}]"
			switch button
				when 'center'	
					@eventBus.trigger "device.screen.prev"