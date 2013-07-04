require [
	"underscore",
	"backbone",
	"view/Device-view",
	"model/DeviceSettings-model"
	"view/MenuScreen-view",
	"view/MenuItem-view"
	], 
	(_, Backbone, Device, DeviceSettings, MenuScreenView, MenuItem) ->
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
					text: DeviceSettings.get "screenBrightness"
				new MenuItem
					title: "Включен, мин"
					text: DeviceSettings.get "screenTimeout"
				new MenuItem
					title: "Включен Всегда"
					text: if DeviceSettings.get "screenAlwaysOn" then 'Да' else 'Нет'
				new MenuItem
					title: "Тема"
					text: DeviceSettings.get "screenTheme"
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

		LanguageSettingsMenuScree = new MenuScreenView
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

		MeasurementMenuScreen = new MenuScreenView
			name: "measurement-menu"
			title: "Измерение"
			items: [
				new MenuItem
					title: "Абрикос"
				new MenuItem
					title: "Арбуз"
				new MenuItem
					title: "Банан"
				new MenuItem
					title: "Баклажан"
				new MenuItem
					title: "Виноград"
				new MenuItem
					title: "Груша"
				new MenuItem
					title: "Зелень"
				new MenuItem
					title: "Дыня"
				new MenuItem
					title: "Капуста ранняя"
				new MenuItem
					title: "Капуста поздняя"
				new MenuItem
					title: "Кабачок"
				new MenuItem
					title: "Картофель"
				new MenuItem
					title: "Клубника"
				new MenuItem
					title: "Лук	репчатый"
				new MenuItem
					title: "Лук зеленый"
				new MenuItem
					title: "Морковь ранняя"
				new MenuItem
					title: "Морковь поздняя"
				new MenuItem
					title: "Нектарин"
				new MenuItem
					title: "Огурец. Грунт"
				new MenuItem
					title: "Огурец. Теплич."
				new MenuItem
					title: "Перец сладкий"
				new MenuItem
					title: "Помидор. Грунт"
				new MenuItem
					title: "Помидор. Теплич."
				new MenuItem
					title: "Редис"
				new MenuItem
					title: "Редька"
				new MenuItem
					title: "Салат"
				new MenuItem
					title: "Свекла"
				new MenuItem
					title: "Хурма"
				new MenuItem
					title: "Яблоко"
				new MenuItem
					title: "Детская норма"
				new MenuItem
					title: "Мясо свежее"
			]
		
		Device.addScreen StartMenuScreen
		Device.addScreen MainMenuScreen
		Device.addScreen SettingsMenuScreen
		Device.addScreen ScreenSettingsMenuScreen
		Device.addScreen PowerSettingsMenuScreen
		Device.addScreen MeasurementMenuScreen
		Device.addScreen LanguageSettingsMenuScree

		Device.setCurrentScreen "start-menu"