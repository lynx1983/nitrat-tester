define ["backbone"], (Backbone)->
	class DeviceSettingsModel extends Backbone.Model
		defaults: ->
			id: "0005"
			version: "1.C"
			autoOffTime: 20
			haveAccumulator: true
			preventOff: true
			screenBrightness: 'middle'
			screenTimeout: 3
			screenAlwaysOn: true
			screenTheme: 'Зеленая'
			language: 'ru'

		getValueString: (valueName)->
			switch valueName
				when 'language'
					if @.get(valueName) == 'ru' then 'Русский' else 'English'
				when 'screenBrightness'
					switch @.get(valueName)
						when 'middle' 
							'Средняя'
						when 'high' 
							'Высокая'
						when 'low' 
							'Низкая'
						else 
							''
				else 
					@.get(valueName)

	new DeviceSettingsModel