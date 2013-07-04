require [
	"underscore",
	"backbone",
	"view/Device-view",
	"model/DeviceSettings-model"
	"view/MenuScreen-view",
	"view/ViewMenuItem-view"
	"view/TextMenuItem-view"
	], 
	(_, Backbone, Device, DeviceSettings, MenuScreenView, ViewMenuItem, TextMenuItem) ->
		StartMenuScreen = new MenuScreenView
			name: "start-menu"
			items: [
				new ViewMenuItem
					title: "Измерение"
				new ViewMenuItem
					title: "Главное меню"
					screen: "main-menu"
			]

		MainMenuScreen = new MenuScreenView
			name: "main-menu"
			title: "Главное меню"
			items: [
				new TextMenuItem
					title: "Язык"
					text: if DeviceSettings.get("language") == "ru" then "Русский" else "Английский"
				new ViewMenuItem
					title: "Настройки"
					screen: "settings-menu"
				new ViewMenuItem
					title: "Информация"
				new TextMenuItem
					title: "Версия ПО"
					text: DeviceSettings.get "version"
				new TextMenuItem
					title: "ID"
					text: DeviceSettings.get "id"
			]

		SettingsMenuScreen = new MenuScreenView
			name: "settings-menu"
			title: "Настройки"
			items: [
				new ViewMenuItem
					title: "Изображение"
					screen: "screen-settings-menu"
				new ViewMenuItem
					title: "Питание"
					screen: "power-settings-menu"
			]

		ScreenSettingsMenuScreen = new MenuScreenView
			name: "screen-settings-menu"
			title: "Изображение"
			items: [
				new TextMenuItem
					title: "Яркость"
					text: DeviceSettings.get "screenBrightness"
				new TextMenuItem
					title: "Включен, мин"
					text: DeviceSettings.get "screenTimeout"
				new TextMenuItem
					title: "Включен Всегда"
					text: if DeviceSettings.get "screenAlwaysOn" then 'Да' else 'Нет'
				new TextMenuItem
					title: "Тема"
					text: DeviceSettings.get "screenTheme"
			]

		PowerSettingsMenuScreen = new MenuScreenView
			name: "power-settings-menu"
			title: "Питание"
			items: [
				new TextMenuItem
					title: "Аккумуляторы"
					text: if DeviceSettings.get "haveAccumulator" then 'Да' else 'Нет'
				new TextMenuItem
					title: "Автовыкл, мин"
					text: DeviceSettings.get "autoOffTime"
				new TextMenuItem
					title: "Не выключать"
					text: if DeviceSettings.get "preventOff" then 'Да' else 'Нет'
			]
		
		Device.addScreen StartMenuScreen
		Device.addScreen MainMenuScreen
		Device.addScreen SettingsMenuScreen
		Device.addScreen ScreenSettingsMenuScreen
		Device.addScreen PowerSettingsMenuScreen

		Device.setCurrentScreen "start-menu"