define ["backbone", "data/Presets-data"], (Backbone, Presets)->
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
			screenTheme: 'green'
			language: 'ru'
			MPCdata: Presets			
			measurementMPC: if Presets.length > 0 then 0 else null

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

		getCurrentMPC:->
			return @get('MPCdata')[@get('measurementMPC')] if @get('measurementMPC')?

	new DeviceSettingsModel