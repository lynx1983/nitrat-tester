require [
	"underscore"
	"backbone"
	"domReady"
	"i18n/i18n"
	"global"
	"model/DeviceSettings-model"
	"view/Device-view"
	"view/TopPanel-view"
	"view/BottomPanel-view"
	"view/MenuScreen-view"
	"view/MenuItem-view"
	"view/TemplatedScreen-view"
	"view/MeasurementScreen-view"
	"view/SearchScreen-view"
	"view/CumulativeDoseScreen-view"
	"view/SplashScreen-view"
	"collection/Measurements-collection"
	"view/DeviceControl-view"
	"view/DemoControl-view"
	], 
	(_, Backbone, domReady, i18n, global, DeviceSettings, Device, TopPanel, BottomPanel, MenuScreenView, MenuItem, TemplatedScreenView, MeasurementScreenView, SearchScreenView, CumulativeDoseScreenView, SplashScreenView, Measurements)->
		domReady ->
                        DeviceSettings.i18n = i18n

			global.device = Device

			Device.topPanel = new TopPanel
			Device.bottomPanel = new BottomPanel

			StartMenuScreen = new MenuScreenView
				name: "start-menu"
				title: "Menu"
				items: [
					new MenuItem
						title: "Measure"
						screen: "measurement-screen"
					new MenuItem
						title: "Search"
						screen: "search-screen"
					new MenuItem
						title: "Сumulative dose"
						screen: "cumulative-dose-screen"
					new MenuItem
						title: "Settings"
						screen: "settings"
				]

			MainMenuScreen = new MenuScreenView
				name: "settings"
				title: "Settings"
				items: [
					new MenuItem
						title: "Config"
						screen: "settings-menu"
					new MenuItem
						title: "Language"
						screen: "language-setting-menu"
					new MenuItem
						title: "Dosage reset"
						screen: "dosage-reset-menu"
					new MenuItem
						title: "Exit"
						class: "exit"
						screen: "__prevScreen__"
				]

			DosageResetScreen = new MenuScreenView
				name: "dosage-reset-menu"
				title: "Dosage reset"
				items: [
					new MenuItem
						title: "Cancel"
						back: true
					new MenuItem
						title: "Reset"
						action: ->
							console.log "Reset action"
							Measurements.cumulativeDose = 0
							@eventBus.trigger "device.screen.msg",
								text: "Zeroed"
				]

			UnitSettingsMenuScreen = new MenuScreenView
				name: "unit-setting-menu"
				title: "Units"
				items: [
					new MenuItem
						title: "Sievert"
						checkbox: true
						settingsValue: "unit"
						checkedValue: 'sievert'
					new MenuItem
						title: "Roentgen"
						checkbox: true
						settingsValue: "unit"
						checkedValue: 'roentgen'
				]

			SettingsMenuScreen = new MenuScreenView
				name: "settings-menu"
				title: "Settings"
				items: [
					new MenuItem
						title: "Level, mcSv/h"
						settingsValue: "threshold"
						showSettingsValue: "thresholdSv"
						showValue: true
						screen: "threshold-sievert-settings-menu"
					new MenuItem
						title: "Dose level"
						settingsValue: "doseThreshold"
						showSettingsValue: "doseThresholdSv"
						showValue: true
						screen: "dose-threshold-sievert-settings-menu"
					new MenuItem
						title: "Exit"
						class: "exit"
						screen: "__prevScreen__"
				]

			ScreenSettingsMenuScreen = new MenuScreenView
				name: "screen-settings-menu"
				title: "Vision"
				items: [
					new MenuItem
						title: "Bright"
						showValue: true
						settingsValue: "screenBrightness"
						screen: "screen-brightness-settings-menu"
					new MenuItem
						title: "On, minute"
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
						title: "Аккумуляторы"
						text: if DeviceSettings.get "haveAccumulator" then 'Yes' else 'No'
					new MenuItem
						title: "Autooff, min"
						text: DeviceSettings.get "autoOffTime"
					new MenuItem
						title: "Dont off"
						text: if DeviceSettings.get "preventOff" then 'Yes' else 'No'
				]

			SoundSettingsMenuScreen = new MenuScreenView
				name: "sound-settings-menu"
				title: "Sound"
				items: [
					new MenuItem
						title: "Sound on"
						text: if DeviceSettings.get "soundOn" then 'Yes' else 'No'
					new MenuItem
						title: "Buttons sound"
						text: if DeviceSettings.get "buttonsSound" then 'Yes' else 'No'
					new MenuItem
						title: "Sensor sound"
						text: if DeviceSettings.get "sensorSound" then 'Yes' else 'No'
					new MenuItem
						title: "Level sound"
						text: if DeviceSettings.get "thresholdSound" then 'Yes' else 'No'
					new MenuItem
						title: "Tone"				
					new MenuItem
						title: "Volume"
						text: DeviceSettings.get "volume"
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
					new MenuItem
						title: "Exit"
						class: "exit"
						screen: "__prevScreen__"
				]

			ScreenBrightnessSettingsScreen = new MenuScreenView
				name: "screen-brightness-settings-menu"
				title: "Bright"
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

			ThresholdSvSettingsScreen = new MenuScreenView
				name: "threshold-sievert-settings-menu"
				title: "Level, mcSv/h"
				items: [
					new MenuItem
						title: "0,3"
						checkbox: true
						settingsValue: "threshold"
						checkedValue: 300
						align: "center"
					new MenuItem
						title: "0,4"
						checkbox: true
						settingsValue: "threshold"
						checkedValue: 400
						align: "center"
					new MenuItem
						title: "0,5"
						checkbox: true
						settingsValue: "threshold"
						checkedValue: 500
						align: "center"
					new MenuItem
						title: "0,6"
						checkbox: true
						settingsValue: "threshold"
						checkedValue: 600
						align: "center"
					new MenuItem
						title: "0,7"
						checkbox: true
						settingsValue: "threshold"
						checkedValue: 700
						align: "center"
					new MenuItem
						title: "0,8"
						checkbox: true
						settingsValue: "threshold"
						checkedValue: 800
						align: "center"
					new MenuItem
						title: "0,9"
						checkbox: true
						settingsValue: "threshold"
						checkedValue: 900
						align: "center"
					new MenuItem
						title: "1"
						checkbox: true
						settingsValue: "threshold"
						checkedValue: 1000
						align: "center"
					new MenuItem
						title: "1,2"
						checkbox: true
						settingsValue: "threshold"
						checkedValue: 1200
						align: "center"
					new MenuItem
						title: "1,5"
						checkbox: true
						settingsValue: "threshold"
						checkedValue: 1500
						align: "center"
					new MenuItem
						title: "2"
						checkbox: true
						settingsValue: "threshold"
						checkedValue: 2000
						align: "center"
					new MenuItem
						title: "5"
						checkbox: true
						settingsValue: "threshold"
						checkedValue: 5000
						align: "center"
					new MenuItem
						title: "10"
						checkbox: true
						settingsValue: "threshold"
						checkedValue: 10000
						align: "center"
					new MenuItem
						title: "20"
						checkbox: true
						settingsValue: "threshold"
						checkedValue: 20000
						align: "center"
					new MenuItem
						title: "50"
						checkbox: true
						settingsValue: "threshold"
						checkedValue: 50000
						align: "center"
					new MenuItem
						title: "100"
						checkbox: true
						settingsValue: "threshold"
						checkedValue: 100000
						align: "center"
					new MenuItem
						title: "Exit"
						class: "exit"
						screen: "__prevScreen__"
				]

			DoseThresholdSvSettingsScreen = new MenuScreenView
				name: "dose-threshold-sievert-settings-menu"
				title: "Dose level"
				items: [
					new MenuItem
						title: "No"
						checkbox: true
						settingsValue: "doseThreshold"
						checkedValue: 0
						align: "center"
					new MenuItem
						title: "0,01 mSv"
						checkbox: true
						settingsValue: "doseThreshold"
						checkedValue: 10000
						align: "center"
					new MenuItem
						title: "0,05 mSv"
						checkbox: true
						settingsValue: "doseThreshold"
						checkedValue: 50000
						align: "center"
					new MenuItem
						title: "0,1 mSv"
						checkbox: true
						settingsValue: "doseThreshold"
						checkedValue: 100000
						align: "center"
					new MenuItem
						title: "0,5 mSv"
						checkbox: true
						settingsValue: "doseThreshold"
						checkedValue: 500000
						align: "center"
					new MenuItem
						title: "1 mSv"
						checkbox: true
						settingsValue: "doseThreshold"
						checkedValue: 1000000
						align: "center"
					new MenuItem
						title: "5 mSv"
						checkbox: true
						settingsValue: "doseThreshold"
						checkedValue: 5000000
						align: "center"
					new MenuItem
						title: "10 mSv"
						checkbox: true
						settingsValue: "doseThreshold"
						checkedValue: 10000000
						align: "center"
					new MenuItem
						title: "50 mSv"
						checkbox: true
						settingsValue: "doseThreshold"
						checkedValue: 50000000
						align: "center"
					new MenuItem
						title: "0,1 Sv"
						checkbox: true
						settingsValue: "doseThreshold"
						checkedValue: 100000000
						align: "center"
					new MenuItem
						title: "0,5 Sv"
						checkbox: true
						settingsValue: "doseThreshold"
						checkedValue: 500000000
						align: "center"
					new MenuItem
						title: "1 Sv"
						checkbox: true
						settingsValue: "doseThreshold"
						checkedValue: 1000000000
						align: "center"
					new MenuItem
						title: "5 Sv"
						checkbox: true
						settingsValue: "doseThreshold"
						checkedValue: 5000000000
						align: "center"
					new MenuItem
						title: "10 Sv"
						checkbox: true
						settingsValue: "doseThreshold"
						checkedValue: 10000000000
						align: "center"
					new MenuItem
						title: "50 Sv"
						checkbox: true
						settingsValue: "doseThreshold"
						checkedValue: 50000000000
						align: "center"
					new MenuItem
						title: "100 Sv"
						checkbox: true
						settingsValue: "doseThreshold"
						checkedValue: 100000000000
						align: "center"
					new MenuItem
						title: "Exit"
						class: "exit"
						screen: "__prevScreen__"
				]

			ScreenTimeoutSettingsScreen = new MenuScreenView
				name: "screen-timeout-settings-menu"
				title: "Turned on, min"
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

			MeasurementScreen = new MeasurementScreenView
				name: "measurement-screen";
				title: "Radioactivity"
				template: '#measurement-screen-template'

			SearchScreen = new SearchScreenView
				name: "search-screen";
				title: "Search"
				template: '#search-screen-template'

			CumulativeDoseScreen = new CumulativeDoseScreenView
				name: "cumulative-dose-screen";
				title: "Cumulative dose"
				template: '#cumulativedose-screen-template'

			SplashScreen = new SplashScreenView
				name: "start-screen"
				nextScreen: 'start-menu'
				noTrackScreen: true
			
			Device.addScreen StartMenuScreen
			Device.addScreen MainMenuScreen
			Device.addScreen SettingsMenuScreen
			Device.addScreen UnitSettingsMenuScreen
			Device.addScreen ScreenSettingsMenuScreen
			Device.addScreen PowerSettingsMenuScreen
			Device.addScreen SoundSettingsMenuScreen
			Device.addScreen LanguageSettingsMenuScreen
			Device.addScreen ScreenBrightnessSettingsScreen
			Device.addScreen ScreenTimeoutSettingsScreen
			Device.addScreen ThresholdSvSettingsScreen
			Device.addScreen DoseThresholdSvSettingsScreen
			Device.addScreen ThemeSettingsScreen
			Device.addScreen InformationScreen
			Device.addScreen MeasurementScreen
			Device.addScreen SearchScreen
			Device.addScreen CumulativeDoseScreen
			Device.addScreen SplashScreen
			Device.addScreen DosageResetScreen

			DeviceSettings.set 
				language: (navigator.language ? navigator.userLanguage ? 'en')[0...2]

			do Device.start