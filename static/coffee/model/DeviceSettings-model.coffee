define ["backbone"], (Backbone)->
	class DeviceSettingsModel extends Backbone.Model
		defaults: ->
			id: "0005"
			version: "1.C"
			autoOffTime: 20
			haveAccumulator: true
			preventOff: true
			screenBrightness: ' Высокая'
			screenTimeout: 3
			screenAlwaysOn: true
			screenTheme: 'Зеленая'
			language: 'ru'

	new DeviceSettingsModel