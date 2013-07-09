require [
	"underscore",
	"backbone",
	"view/Device-view",
	"model/DeviceSettings-model"
	"view/MenuScreen-view",
	"view/MenuItem-view",
	"view/TemplatedScreen-view"
	"view/CalibrationScreen-view"
	"view/PreMeasurementScreen-view"
	"view/MeasurementResultScreen-view"
	"view/SplashScreen-view"
	"data/Presets-data"
	], 
	(_, Backbone, Device, DeviceSettings, MenuScreenView, MenuItem, TemplatedScreenView, CalibrationScreenView, PreMeasurementScreenView, MeasurementResultScreenView, SplashScreenView, Presets) ->
		StartMenuScreen = new MenuScreenView
			name: "start-menu"
			items: [
				new MenuItem
					title: "Измерение"
					screen: "measurement-menu"
				new MenuItem
					title: "Главное меню"
					screen: "main-menu"
			]

		MainMenuScreen = new MenuScreenView
			name: "main-menu"
			title: "Главное меню"
			items: [
				new MenuItem
					title: "Язык"
					settingsValue: "language"
					showValue: true
					screen: "language-setting-menu"
				new MenuItem
					title: "Настройки"
					screen: "settings-menu"
				new MenuItem
					title: "Информация"
					screen: "information-screen"
				new MenuItem
					title: "Версия ПО"
					text: DeviceSettings.get "version"
				new MenuItem
					title: "ID"
					text: DeviceSettings.get "id"
			]

		SettingsMenuScreen = new MenuScreenView
			name: "settings-menu"
			title: "Настройки"
			items: [
				new MenuItem
					title: "Изображение"
					screen: "screen-settings-menu"
				new MenuItem
					title: "Питание"
					screen: "power-settings-menu"
			]

		ScreenSettingsMenuScreen = new MenuScreenView
			name: "screen-settings-menu"
			title: "Изображение"
			items: [
				new MenuItem
					title: "Яркость"
					showValue: true
					settingsValue: "screenBrightness"
					screen: "screen-brightness-settings-menu"
				new MenuItem
					title: "Включен, мин"
					settingsValue: "screenTimeout"
					showValue: true
					screen: "screen-timeout-settings-menu"
				new MenuItem
					title: "ВключенВсегда"
					text: if DeviceSettings.get "screenAlwaysOn" then 'Да' else 'Нет'
				new MenuItem
					title: "Тема"
					settingsValue: "screenTheme"
					showValue: true
					screen: "theme-settings-menu"
			]

		PowerSettingsMenuScreen = new MenuScreenView
			name: "power-settings-menu"
			title: "Питание"
			items: [
				new MenuItem
					title: "Аккумуляторы"
					text: if DeviceSettings.get "haveAccumulator" then 'Да' else 'Нет'
				new MenuItem
					title: "Автовыкл, мин"
					text: DeviceSettings.get "autoOffTime"
				new MenuItem
					title: "Не выключать"
					text: if DeviceSettings.get "preventOff" then 'Да' else 'Нет'
			]

		LanguageSettingsMenuScreen = new MenuScreenView
			name: "language-setting-menu"
			title: "Язык"
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
			title: "Яркость"
			items: [
				new MenuItem
					title: "Низкая"
					checkbox: true
					settingsValue: "screenBrightness"
					checkedValue: 'low'
				new MenuItem
					title: "Средня"
					checkbox: true
					settingsValue: "screenBrightness"
					checkedValue: 'middle'
				new MenuItem
					title: "Высокая"
					checkbox: true
					settingsValue: "screenBrightness"
					checkedValue: 'high'
			]

		ThemeSettingsScreen = new MenuScreenView
			name: "theme-settings-menu"
			title: "Тема"
			items: [
				new MenuItem
					title: "Зеленая"
					checkbox: true
					settingsValue: "screenTheme"
					checkedValue: 'green'
				new MenuItem
					title: "Серая"
					checkbox: true
					settingsValue: "screenTheme"
					checkedValue: 'gray'
				new MenuItem
					title: "Синяя"
					checkbox: true
					settingsValue: "screenTheme"
					checkedValue: 'blue'
				new MenuItem
					title: "Белая"
					checkbox: true
					settingsValue: "screenTheme"
					checkedValue: 'white'
			]

		ScreenTimeoutSettingsScreen = new MenuScreenView
			name: "screen-timeout-settings-menu"
			title: "Включен, мин"
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
			title: "Измерение"
			items: items

		InformationScreen = new TemplatedScreenView
			name: "information-screen"
			title: "Информация"
			template: '#info-screen-template'
			events: [
				name: 'button.click'
				callback: (button)->
					@eventBus.trigger "device.screen.prev" if button == 'left'
			]

		CalibrationScreen = new CalibrationScreenView
			name: "calibration-screen"
			title: "Нитрат-тестер"
			template: '#calibration-screen-template'
			nextScreen: 'pre-measurement-screen'
			noTrackScreen: true

		BeforeMeasurementScreen = new TemplatedScreenView
			name: "before-measurement-screen"
			title: "Нитрат-тестер"
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
			title: "Нитрат-тестер"
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
			title: "Нитрат-тестер"
			direction: 'down'
			template: '#measurement-screen-template'
			nextScreen: 'measurement-result-screen'
			noTrackScreen: true

		MeasurementResultScreen = new MeasurementResultScreenView
			name: "measurement-result-screen";
			title: "Нитрат-тестер"
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

		Device.setCurrentScreen "splash-screen"