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
					screen: "measurement-menu"
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

		MeasurementMenuScreen = new MenuScreenView
			name: "measurement-menu"
			title: "Измерение"
			items: [
				new ViewMenuItem
					title: "Абрикос"
				new ViewMenuItem
					title: "Арбуз"
				new ViewMenuItem
					title: "Банан"
				new ViewMenuItem
					title: "Баклажан"
				new ViewMenuItem
					title: "Виноград"
				new ViewMenuItem
					title: "Груша"
				new ViewMenuItem
					title: "Зелень"
				new ViewMenuItem
					title: "Дыня"
				new ViewMenuItem
					title: "Капуста ранняя"
				new ViewMenuItem
					title: "Капуста поздняя"
				new ViewMenuItem
					title: "Кабачок"
				new ViewMenuItem
					title: "Картофель"
				new ViewMenuItem
					title: "Клубника"
				new ViewMenuItem
					title: "Лук	репчатый"
				new ViewMenuItem
					title: "Лук зеленый"
				new ViewMenuItem
					title: "Морковь ранняя"
				new ViewMenuItem
					title: "Морковь поздняя"
				new ViewMenuItem
					title: "Нектарин"
				new ViewMenuItem
					title: "Огурец. Грунт"
				new ViewMenuItem
					title: "Огурец. Теплич."
				new ViewMenuItem
					title: "Перец сладкий"
				new ViewMenuItem
					title: "Помидор. Грунт"
				new ViewMenuItem
					title: "Помидор. Теплич."
				new ViewMenuItem
					title: "Редис"
				new ViewMenuItem
					title: "Редька"
				new ViewMenuItem
					title: "Салат"
				new ViewMenuItem
					title: "Свекла"
				new ViewMenuItem
					title: "Хурма"
				new ViewMenuItem
					title: "Яблоко"
				new ViewMenuItem
					title: "Детская норма"
				new ViewMenuItem
					title: "Мясо свежее"
			]
		
		Device.addScreen StartMenuScreen
		Device.addScreen MainMenuScreen
		Device.addScreen SettingsMenuScreen
		Device.addScreen ScreenSettingsMenuScreen
		Device.addScreen PowerSettingsMenuScreen
		Device.addScreen MeasurementMenuScreen

		Device.setCurrentScreen "start-menu"