define [
	"view/TemplatedScreen-view"
	"model/DeviceSettings-model"
	"collection/Measurements-collection"
	"i18n/i18n"
	], (TemplatedScreenView, DeviceSettings, Measurements, i18n)->
	class CumulativeDoseScreenView extends TemplatedScreenView
		initialize:->
			@template = _.template $(@options.template).html()
			@tag = ''
			@lastValue = ''
			@accuracy = 0
			@maxAccuracy = 12

		strPad:(number, length)->
			str = "#{number}";
			while str.length < length
				str = "0#{str}"
			str

		render:->
			value = Measurements.cumulativeDose

			if DeviceSettings.get("unit") is "sievert"
				formattedValue = value / 1000
			else
				formattedValue = value / 100

			formattedValue = formattedValue.toFixed(2).replace ".", ","

			level = DeviceSettings.getValueString "doseThresholdSv"

			level = level.toFixed(2).replace ".", ","

			time = new Date().getTime() - Measurements.startTime

			time = time / 1000

			hours = Math.floor time / (60 * 60 )

			time -= hours * 60 * 60

			minutes = Math.floor time / 60

			seconds = Math.floor time - minutes * 60

			@$el.html @template
				t: i18n.t
				title: @title
				value: formattedValue
				level: "#{level} Sv/h"
				time: "#{@strPad(hours, 3)}:#{@strPad(minutes, 2)}:#{@strPad(seconds, 2)}"
			@

		activate:->
			super
			console.log "Screen [#{@name}] custom activate"
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