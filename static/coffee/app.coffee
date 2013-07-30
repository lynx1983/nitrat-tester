require [
	"underscore",
	"backbone",
	"domReady",
	"i18n/i18n",
	"model/DeviceSettings-model"	
	"view/Device-view",
	"view/MenuScreen-view",
	"view/MenuItem-view",
	"view/TemplatedScreen-view"
	"view/MeasurementResultScreen-view"
	"view/SplashScreen-view"
	], 
	(_, Backbone, domReady, i18n, DeviceSettings, Device, MenuScreenView, MenuItem, TemplatedScreenView, MeasurementResultScreenView, SplashScreenView) ->
		domReady ->
			StartMenuScreen = new MenuScreenView
				name: "start-menu"
				items: [
					new MenuItem
						title: "Main menu"
						screen: "main-menu"
					new MenuItem
						title: "Measurement"
						screen: "measurement-menu"
				]

			MainMenuScreen = new MenuScreenView
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

			SettingsMenuScreen = new MenuScreenView
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

			ScreenSettingsMenuScreen = new MenuScreenView
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

			PowerSettingsMenuScreen = new MenuScreenView
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

			LanguageSettingsMenuScreen = new MenuScreenView
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

			SoundSettingsMenuScreen = new MenuScreenView
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

			ScreenBrightnessSettingsScreen = new MenuScreenView
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

			ScreenTimeoutSettingsScreen = new MenuScreenView
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

			InformationScreen = new TemplatedScreenView
				name: "information-screen"
				title: "Information"
				template: '#info-screen-template'
				events: [
					name: 'button.click'
					callback: (button)->
						@eventBus.trigger "device.screen.prev" if button == 'left'
				]

			MeasurementResultScreen = new MeasurementResultScreenView
				name: "measurement-result-screen";
				title: "Nitrat-tester"
				template: '#measurement-result-screen-template'
				events: [
					name: 'button.click'
					callback: (button)->
						if button == 'left'
							@eventBus.trigger "device.screen.prev" 
				]

			SplashScreen = new SplashScreenView
				name: "splash-screen"
				nextScreen: 'start-menu'
				noTrackScreen: true
			
			Device.addScreen StartMenuScreen
			Device.addScreen MainMenuScreen
			Device.addScreen SettingsMenuScreen
			Device.addScreen ScreenSettingsMenuScreen
			Device.addScreen PowerSettingsMenuScreen
			Device.addScreen SoundSettingsMenuScreen
			Device.addScreen LanguageSettingsMenuScreen
			Device.addScreen ScreenBrightnessSettingsScreen
			Device.addScreen ScreenTimeoutSettingsScreen
			Device.addScreen InformationScreen
			Device.addScreen MeasurementResultScreen
			Device.addScreen SplashScreen

			DeviceSettings.set
				language: (navigator.language || navigator.userLanguage || 'en').substring 0, 2

			Device.setCurrentScreen "splash-screen"