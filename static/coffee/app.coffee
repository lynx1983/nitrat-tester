require ["underscore", "backbone", "view/Device-view", "view/MenuScreen-view", "view/ViewMenuItem-view"], 
	(_, Backbone, DeviceView, MenuScreenView, ViewMenuItem) ->
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
			items: [
				new ViewMenuItem
					title: "Настройки"
				new ViewMenuItem
					title: "Информация"
			]
		
		DeviceView.addScreen StartMenuScreen
		DeviceView.addScreen MainMenuScreen

		DeviceView.setCurrentScreen "start-menu"