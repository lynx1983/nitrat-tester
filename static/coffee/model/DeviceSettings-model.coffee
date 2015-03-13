define ["backbone"], (Backbone)->
	class DeviceSettingsModel extends Backbone.Model
		defaults:->
			version: "2.0"
			autoOffTime: 20
			haveAccumulator: yes
			screenBrightness: 'middle'
			screenTimeout: 3
			screenAlwaysOn: yes
			soundOn: yes
			buttonsSound: yes
			normSound: yes
			tone: 3
			volume: 'middle'
			language: ''

		getValueString: (valueName)->
			switch valueName
				when 'language'
					@i18n.getLanguageName @get valueName
				else 
					@get valueName

	new DeviceSettingsModel