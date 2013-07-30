define ["backbone", "data/Presets-data"], (Backbone, Presets)->
	class DeviceSettingsModel extends Backbone.Model
		defaults: ->
			version: "2.0"
			autoOffTime: 20
			haveAccumulator: true
			preventOff: true
			screenBrightness: 'middle'
			screenTimeout: 3
			screenAlwaysOn: true
			screenTheme: 'green'
			language: ''

		getValueString: (valueName)->
			switch valueName
				when 'language'
					if @.get(valueName) == 'ru' then 'Русский' else 'English'
				when 'screenBrightness'
					switch @.get(valueName)
						when 'middle' 
							'Middle'
						when 'high' 
							'High'
						when 'low' 
							'Low'
						else 
							''
				when 'screenTheme'
					switch @.get(valueName)
						when 'green'
							'Зеленая'
						when 'gray'
							'Серая'
						when 'blue'
							'Синяя'
						when 'white'
							'Белая'
						else
							''
				else 
					@.get(valueName)

	new DeviceSettingsModel