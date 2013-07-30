define ["backbone", "data/Presets-data"], (Backbone, Presets)->
	class DeviceSettingsModel extends Backbone.Model
		defaults: ->
			version: "2.0"
			autoOffTime: 20
			haveAccumulator: true
			screenBrightness: 'middle'
			screenTimeout: 3
			screenAlwaysOn: true
			soundOn: true,
			buttonsSound: true,
			normSound: true,
			tone: 3,
			volume: 'middle'
			language: ''

		getValueString: (valueName)->
			switch valueName
				when 'language'
					if @.get(valueName) == 'ru' then 'Русский' else 'English'
				else 
					@.get(valueName)

	new DeviceSettingsModel