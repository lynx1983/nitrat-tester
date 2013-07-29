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
	"view/CalibrationScreen-view"
	"view/PreMeasurementScreen-view"
	"view/MeasurementResultScreen-view"
	"view/SplashScreen-view"
	"data/Presets-data"
	], 
	(_, Backbone, domReady, i18n, DeviceSettings, Device, MenuScreenView, MenuItem, TemplatedScreenView, CalibrationScreenView, PreMeasurementScreenView, MeasurementResultScreenView, SplashScreenView, Presets) ->
		domReady ->
			StartMenuScreen = new MenuScreenView
				name: "start-menu"
				items: [
					new MenuItem
						title: "Measurement"
						screen: "measurement-menu"
					new MenuItem
						title: "Main menu"
						screen: "main-menu"
				]

			MainMenuScreen = new MenuScreenView
				name: "main-menu"
				title: "Main menu"
				items: [
					new MenuItem
						title: "Language"
						settingsValue: "language"
						showValue: true
						screen: "language-setting-menu"
					new MenuItem
						title: "Settings"
						screen: "settings-menu"
					new MenuItem
						title: "Information"
						screen: "information-screen"
					new MenuItem
						title: "Version"
						text: DeviceSettings.get "version"
					new MenuItem
						title: "ID"
						text: DeviceSettings.get "id"
				]

			SettingsMenuScreen = new MenuScreenView
				name: "settings-menu"
				title: "Settings"
				items: [
					new MenuItem
						title: "Vision"
						screen: "screen-settings-menu"
					new MenuItem
						title: "Power"
						screen: "power-settings-menu"
				]

			ScreenSettingsMenuScreen = new MenuScreenView
				name: "screen-settings-menu"
				title: "Vision"
				items: [
					new MenuItem
						title: "Brightness"
						showValue: true
						settingsValue: "screenBrightness"
						screen: "screen-brightness-settings-menu"
					new MenuItem
						title: "On, min"
						settingsValue: "screenTimeout"
						showValue: true
						screen: "screen-timeout-settings-menu"
					new MenuItem
						title: "Always ON"
						text: if DeviceSettings.get "screenAlwaysOn" then 'Yes' else 'No'
					new MenuItem
						title: "Theme"
						settingsValue: "screenTheme"
						showValue: true
						screen: "theme-settings-menu"
				]

			PowerSettingsMenuScreen = new MenuScreenView
				name: "power-settings-menu"
				title: "Power"
				items: [
					new MenuItem
						title: "Accumulator"
						text: if DeviceSettings.get "haveAccumulator" then 'Yes' else 'No'
					new MenuItem
						title: "Autooff, min"
						text: DeviceSettings.get "autoOffTime"
					new MenuItem
						title: "Dont off"
						text: if DeviceSettings.get "preventOff" then 'Yes' else 'No'
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

			ThemeSettingsScreen = new MenuScreenView
				name: "theme-settings-menu"
				title: "Theme"
				items: [
					new MenuItem
						title: "Green"
						checkbox: true
						settingsValue: "screenTheme"
						checkedValue: 'green'
					new MenuItem
						title: "Gray"
						checkbox: true
						settingsValue: "screenTheme"
						checkedValue: 'gray'
					new MenuItem
						title: "Blue"
						checkbox: true
						settingsValue: "screenTheme"
						checkedValue: 'blue'
					new MenuItem
						title: "White"
						checkbox: true
						settingsValue: "screenTheme"
						checkedValue: 'white'
				]

			ScreenTimeoutSettingsScreen = new MenuScreenView
				name: "screen-timeout-settings-menu"
				title: "On, min"
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

			items = []
			_.each Presets, (preset, index)->
				items.push new MenuItem
					title: preset.name
					checkbox: true
					settingsValue: "measurementMPC"
					checkedValue: index
					screen: "before-measurement-screen"

			MeasurementMenuScreen = new MenuScreenView
				name: "measurement-menu"
				title: "Measurement"
				items: items

			InformationScreen = new TemplatedScreenView
				name: "information-screen"
				title: "Information"
				template: '#info-screen-template'
				events: [
					name: 'button.click'
					callback: (button)->
						@eventBus.trigger "device.screen.prev" if button == 'left'
				]

			CalibrationScreen = new CalibrationScreenView
				name: "calibration-screen"
				title: "Nitrat-tester"
				template: '#calibration-screen-template'
				nextScreen: 'pre-measurement-screen'
				noTrackScreen: true

			BeforeMeasurementScreen = new TemplatedScreenView
				name: "before-measurement-screen"
				title: "Nitrat-tester"
				template: '#before-measurement-screen-template'
				events: [
					name: 'button.click'
					callback: (button)->
						switch button
							when 'left'
								@eventBus.trigger "device.screen.prev" 
							when 'center'
								@eventBus.trigger "device.cap.open"
								@eventBus.trigger "device.screen.set",
									screenName: 'calibration-screen'
				]
				noTrackScreen: true

			PreMeasurementScreen = new PreMeasurementScreenView
				name: "pre-measurement-screen"
				title: "Nitrat-tester"
				template: '#pre-measurement-screen-template'
				events: [
					name: 'button.click'
					callback: (button)->
						switch button
							when 'left'
								@eventBus.trigger "device.screen.prev" 
							when 'center'
								@eventBus.trigger "device.product.place" 
								@eventBus.trigger "device.screen.set",
									screenName: 'measurement-screen'
				]
				noTrackScreen: true

			MeasurementScreen = new CalibrationScreenView
				name: "measurement-screen"
				title: "Nitrat-tester"
				direction: 'down'
				template: '#measurement-screen-template'
				nextScreen: 'measurement-result-screen'
				noTrackScreen: true

			MeasurementResultScreen = new MeasurementResultScreenView
				name: "measurement-result-screen";
				title: "Nitrat-tester"
				template: '#measurement-result-screen-template'
				events: [
					name: 'button.click'
					callback: (button)->
						if button == 'left'
							@eventBus.trigger "device.cap.close"
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
			Device.addScreen MeasurementMenuScreen
			Device.addScreen LanguageSettingsMenuScreen
			Device.addScreen ScreenBrightnessSettingsScreen
			Device.addScreen ScreenTimeoutSettingsScreen
			Device.addScreen ThemeSettingsScreen
			Device.addScreen InformationScreen
			Device.addScreen BeforeMeasurementScreen
			Device.addScreen CalibrationScreen
			Device.addScreen PreMeasurementScreen
			Device.addScreen MeasurementScreen
			Device.addScreen MeasurementResultScreen
			Device.addScreen SplashScreen

			DeviceSettings.set
				language: (navigator.language || navigator.userLanguage || 'en').substring 0, 2

			Device.setCurrentScreen "splash-screen"
