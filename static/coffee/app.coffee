require [
	"underscore"
	"backbone"
	"domReady"
	"i18n/i18n"
	"model/DeviceSettings-model"
	"view/Device-view"
	"view/MenuScreen-view"
	"view/MenuItem-view"
	"view/TemplatedScreen-view"
	"view/MeasurementScreen-view"
	"view/SplashScreen-view"
	"collection/Measurements-collection"
	"view/Environment-view"
	], 
	(_, Backbone, domReady, i18n, DeviceSettings, Device, MenuScreenView, MenuItem, TemplatedScreenView, MeasurementScreenView, SplashScreenView, Measurements) ->
		domReady ->
			Device.addScreen new MenuScreenView
				name: "start-menu"
				items: [
					new MenuItem
						title: "Main menu"
						screen: "main-menu"
					new MenuItem
						title: "Measurement"
						screen: "indoor-measurement-screen"
				]

			Device.addScreen new MenuScreenView
				name: "main-menu"
				title: "Main menu"
				items: [
					new MenuItem
						title: "Settings"
						screen: "settings-menu"
					new MenuItem
						title: "Information"
						screen: "information-screen"
					new MenuItem
						title: "Language"
						settingsValue: "language"
						showValue: true
						screen: "language-setting-menu"
					new MenuItem
						title: "Version"
						text: DeviceSettings.get "version"
				]

			Device.addScreen new MenuScreenView
				name: "settings-menu"
				title: "Settings"
				items: [
					new MenuItem
						title: "Vision"
						screen: "screen-settings-menu"
					new MenuItem
						title: "Sound"
						screen: "sound-settings-menu"
					new MenuItem
						title: "Power"
						screen: "power-settings-menu"
				]

			Device.addScreen new MenuScreenView
				name: "screen-settings-menu"
				title: "Screen"
				items: [
					new MenuItem
						title: "Brightness"
						showValue: true
						settingsValue: "screenBrightness"
						screen: "screen-brightness-settings-menu"
					new MenuItem
						title: "Autooff, min"
						settingsValue: "screenTimeout"
						showValue: true
						screen: "screen-timeout-settings-menu"
				]

			Device.addScreen new MenuScreenView
				name: "power-settings-menu"
				title: "Power"
				items: [
					new MenuItem
						title: "Аккумуляторы"
						text: if DeviceSettings.get "haveAccumulator" then 'Да' else 'Нет'
					new MenuItem
						title: "Autooff, min"
						text: DeviceSettings.get "autoOffTime"
				]

			Device.addScreen new MenuScreenView
				name: "language-setting-menu"
				title: "Language"
				items: [
					new MenuItem
						title: "Русский"
						checkbox: true
						settingsValue: "language"
						checkedValue: 'ru'
					new MenuItem
						title: "English"
						checkbox: true
						settingsValue: "language"
						checkedValue: 'en'
				]

			Device.addScreen new MenuScreenView
				name: "sound-settings-menu"
				title: "Sound"
				items: [
					new MenuItem
						title: "On"
						text: if DeviceSettings.get "soundOn" then 'Yes' else 'No'
					new MenuItem
						title: "Buttons"
						text: if DeviceSettings.get "buttonsSound" then 'Yes' else 'No'
					new MenuItem
						title: "Norm"
						text: if DeviceSettings.get "normSound" then 'Yes' else 'No'
					new MenuItem
						title: "Tone"
						text: DeviceSettings.get "tone"
					new MenuItem
						title: "Volume"
						text: DeviceSettings.get "volume"
				]

			Device.addScreen new MenuScreenView
				name: "screen-brightness-settings-menu"
				title: "Brightness"
				items: [
					new MenuItem
						title: "Low"
						checkbox: true
						settingsValue: "screenBrightness"
						checkedValue: 'low'
					new MenuItem
						title: "Middle"
						checkbox: true
						settingsValue: "screenBrightness"
						checkedValue: 'middle'
					new MenuItem
						title: "High"
						checkbox: true
						settingsValue: "screenBrightness"
						checkedValue: 'high'
				]

			Device.addScreen new MenuScreenView
				name: "screen-timeout-settings-menu"
				title: "Autooff, min"
				items: [
					new MenuItem
						title: "1"
						checkbox: true
						settingsValue: "screenTimeout"
						checkedValue: 1
					new MenuItem
						title: "3"
						checkbox: true
						settingsValue: "screenTimeout"
						checkedValue: 3
					new MenuItem
						title: "5"
						checkbox: true
						settingsValue: "screenTimeout"
						checkedValue: 5
					new MenuItem
						title: "10"
						checkbox: true
						settingsValue: "screenTimeout"
						checkedValue: 10
					new MenuItem
						title: "15"
						checkbox: true
						settingsValue: "screenTimeout"
						checkedValue: 15
				]

			Device.addScreen new TemplatedScreenView
				name: "information-screen"
				title: "Information"
				template: '#info-screen-template'
				events: [
					name: 'button.click'
					callback: (button)->
						@eventBus.trigger "device.screen.prev" if button is 'left'
				]

			Device.addScreen new MeasurementScreenView
				name: "indoor-measurement-screen"
				environmentTag: "indoor"
				title: "EMF indoor"
				template: '#measurement-screen-template'
				electricLevel: 500
				electricMax: 2000
				magneticLevel: 10
				magneticMax: 25
				events: [
					name: 'button.click'
					callback: (button)->
						if button is 'center'
							@eventBus.trigger "device.screen.set",
								screenName: "start-menu"
						if button is 'right'
							@eventBus.trigger "device.screen.set", 
								screenName: "living-area-measurement-screen" 
				]
				noTrackScreen: true

			Device.addScreen new MeasurementScreenView
				name: "living-area-measurement-screen"
				environmentTag: "outdoor"
				title: "EMF living area"
				template: '#measurement-screen-template'
				electricLevel: 1000
				electricMax: 5000
				magneticLevel: 25
				magneticMax: 50
				events: [
					name: 'button.click'
					callback: (button)->
						if button is 'center'
							@eventBus.trigger "device.screen.set",
								screenName: "start-menu"
						if button is 'right'
							@eventBus.trigger "device.screen.set", 
								screenName: "pc-measurement-screen"
				]
				noTrackScreen: true

			Device.addScreen new MeasurementScreenView
				name: "pc-measurement-screen"
				environmentTag: "pc"
				title: "EMF PC"
				template: '#measurement-screen-template'
				electricLevel: 25
				electricMax: 50
				magneticLevel: .25
				magneticMax: 500
				events: [
					name: 'button.click'
					callback: (button)->
						if button is 'center'
							@eventBus.trigger "device.screen.set",
								screenName: "start-menu"
						if button is 'right'
							@eventBus.trigger "device.screen.set", 
								screenName: "view-measurement-screen"  
				]
				noTrackScreen: true

			Device.addScreen new MeasurementScreenView
				name: "view-measurement-screen"
				title: "View"
				template: '#measurement-view-screen-template'
				electricLevel: 0
				electricMax: 3300
				magneticLevel: 0
				magneticMax: 500
				events: [
					name: 'button.click'
					callback: (button)->
						if button is 'center'
							@eventBus.trigger "device.screen.set",
								screenName: "start-menu"
						if button is 'right'
							@eventBus.trigger "device.screen.set", 
								screenName: "indoor-measurement-screen"  
				]
				noTrackScreen: true

			Device.addScreen new SplashScreenView
				name: "splash-screen"
				nextScreen: 'indoor-measurement-screen'
				noTrackScreen: true
			
			DeviceSettings.set
				language: (navigator.language ? navigator.userLanguage ? 'en')[0...2]

			Device.setCurrentScreen "splash-screen"